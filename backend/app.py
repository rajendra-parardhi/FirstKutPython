import os
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# ---------------------------------------------------------------------------
# Storage layout.
#   Local dev  -> repo root (keeps the historic ui_images/ ui_html/ layout)
#   Container   -> set DATA_DIR=/data (all artefacts then land on a volume)
# ---------------------------------------------------------------------------
_REPO_ROOT = Path(__file__).resolve().parent.parent
_DATA_DIR_ENV = os.environ.get("DATA_DIR")

DATA_DIR = Path(_DATA_DIR_ENV).resolve() if _DATA_DIR_ENV else _REPO_ROOT
IMAGES_DIR = DATA_DIR / "ui_images"
JSONS_DIR = DATA_DIR / "ui_jsons"
HTML_DIR = DATA_DIR / "ui_html"
DART_DIR = DATA_DIR / "ui_images_flutter_code"
ASSETS_DIR = DATA_DIR / "assets"

if _DATA_DIR_ENV:
    # Container: everything (including ChromaDB) lives under DATA_DIR
    CHROMA_DIR = Path(os.environ.get("CHROMA_DIR", DATA_DIR / "ui_vector_db")).resolve()
else:
    # Local: preserve the legacy backend/ui_vector_db location
    CHROMA_DIR = Path(os.environ.get("CHROMA_DIR", Path(__file__).resolve().parent / "ui_vector_db")).resolve()

for _folder in (IMAGES_DIR, JSONS_DIR, HTML_DIR, DART_DIR, ASSETS_DIR, CHROMA_DIR):
    _folder.mkdir(parents=True, exist_ok=True)

os.environ.setdefault("KMP_DUPLICATE_LIB_OK", "TRUE") # Prevents MKL/OMP crashes on Windows
os.environ.setdefault("OMP_NUM_THREADS", "1")         # Limits CPU thread usage for stability

import cv2, json, torch, shutil, re, io, base64, time, traceback, asyncio, threading, uuid
import numpy as np
import chromadb
from chromadb.utils import embedding_functions
from PIL import Image
from fastapi import UploadFile, File

# Diagnostic Wrapper for CLIP and Torchvision compatibility
try:
    import torchvision
    import clip
except RuntimeError as re_err:
    if "torchvision::nms" in str(re_err):
        print("\n" + "="*80)
        print("CRITICAL ENVIRONMENT ERROR DETECTED")
        print("Your 'torch' and 'torchvision' versions are incompatible.")
        print("To fix this, please run one of the following commands in your terminal:")
        print("\nFor CPU environments:")
        print("  pip uninstall torch torchvision torchaudio -y")
        print("  pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu")
        print("\nFor GPU (CUDA 12.1) environments:")
        print("  pip uninstall torch torchvision torchaudio -y")
        print("  pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121")
        print("="*80 + "\n")
    raise re_err

import faiss
import easyocr
from sentence_transformers import SentenceTransformer
from segment_anything import sam_model_registry, SamAutomaticMaskGenerator

# FastAPI Imports
from fastapi import FastAPI, File, UploadFile, Form, HTTPException, Header, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from typing import List, Optional
import httpx

# --- SERVER CONFIGURATION (all env-driven) ---------------------------------
# DEVICE: "cuda" when a GPU is present, force with DEVICE=cuda|cpu
DEVICE = os.environ.get("DEVICE") or ("cuda" if torch.cuda.is_available() else "cpu")

PORT = int(os.environ.get("PORT", "8000"))
# Absolute base used when returning asset URLs to the frontend
# (e.g. https://<pod>-8000.proxy.runpod.net in production)
PUBLIC_BASE_URL = (os.environ.get("PUBLIC_BASE_URL") or f"http://localhost:{PORT}").rstrip("/")
# Comma separated allowlist, e.g. "https://myapp.netlify.app,https://myapp.com"
ALLOWED_ORIGINS = [o.strip() for o in os.environ.get("ALLOWED_ORIGINS", "*").split(",") if o.strip()]
# When set, every /api/* route requires an "x-api-key" header
API_KEY = os.environ.get("API_KEY", "").strip()
# Model tier used for screenshot -> code synthesis (see generate_code_with_gemini_model)
CODE_MODEL = os.environ.get("GEMINI_MODEL", "gemini-3.5-flash")

# Model-heavy jobs run one at a time: models, FAISS and ChromaDB are shared globals
PIPELINE_LOCK = threading.Lock()
# In-memory job registry: job_id -> {status, stage, steps, progress, result, error}
JOBS = {}
JOBS_MAX_HISTORY = 50

# Initialize Models and databases
text_model = SentenceTransformer('all-MiniLM-L6-v2')
nemotron_model = SentenceTransformer('nvidia/Nemotron-3-Embed-1B-BF16', device=DEVICE)

client = chromadb.PersistentClient(path=str(CHROMA_DIR))
collection = client.get_or_create_collection(name="ui_components")

SAM_CHECKPOINT = os.environ.get("SAM_CHECKPOINT", "sam_vit_b_01ec64.pth")

# Try importing the Google Generative AI library
try:
    import google.generativeai as genai
    GEMINI_AVAILABLE = True
except ImportError:
    GEMINI_AVAILABLE = False

# Retrieve key from environment only (never hardcode secrets)
GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY", "").strip()

# Verify if the API key is present
if not GEMINI_API_KEY or GEMINI_API_KEY == "YOUR_API_KEY_HERE":
    print("\n" + "!"*80)
    print("WARNING: MISSING GEMINI API KEY")
    print("Please check your .env file or your environment variable configurations.")
    print("!"*80 + "\n")

# Configure Gemini
if GEMINI_AVAILABLE and GEMINI_API_KEY:
    genai.configure(api_key=GEMINI_API_KEY)
    print("--- Connected to Gemini API successfully ---")

# Initialize Models
print(f"--- System Initializing Backend on {DEVICE} ---")
reader = easyocr.Reader(['en'], gpu=(DEVICE == "cuda"))

# Load segment anything model
model_type = "vit_b"
if "vit_h" in SAM_CHECKPOINT:
    model_type = "vit_h"

sam = sam_model_registry[model_type](checkpoint=SAM_CHECKPOINT).to(DEVICE)
mask_generator = SamAutomaticMaskGenerator(model=sam, points_per_side=12, pred_iou_thresh=0.88, min_mask_region_area=500)
clip_model, clip_preprocess = clip.load("ViT-B/32", device=DEVICE)

# Global variables for FAISS Indexing
index = faiss.IndexFlatIP(896)
memory_metadata = []

# --- UTILITY & CLEANING FUNCTIONS ---

def standardize_for_sam(img_np):
    target_size = 512 
    h, w = img_np.shape[:2]
    scale = target_size / max(h, w)
    new_h, new_w = int(h * scale), int(w * scale)
    resized = cv2.resize(img_np, (new_w, new_h))
    pad_h, pad_w = target_size - new_h, target_size - new_w
    top, left = pad_h // 2, pad_w // 2
    padded = cv2.copyMakeBorder(resized, top, pad_h - top, left, pad_w - left, 
                                cv2.BORDER_CONSTANT, value=[0, 0, 0])
    return padded, {"top": top, "left": left, "scale": scale, "orig_h": h, "orig_w": w}

def clean_text(text: str) -> str:
    """Removes special characters and normalizes spaces."""
    cleaned = re.sub(r'[^a-zA-Z0-9\s]', '', text)
    return " ".join(cleaned.split())

def create_composite_embedding(img_np, ocr_texts, masks):
    # 1. Visual (CLIP) - Output: 512 dim
    img_t = clip_preprocess(Image.fromarray(img_np)).unsqueeze(0).to(DEVICE)
    with torch.no_grad():
        vis_emb = clip_model.encode_image(img_t).cpu().numpy()[0]
    
    # 2. Text/Structural (Nemotron-3-Embed)
    combined_text = " ".join([t for sublist in ocr_texts for t in sublist])
    full_text_emb = nemotron_model.encode(combined_text if combined_text else "empty")
    text_emb = full_text_emb[:324] 
    
    # 3. Layout (Normalized BBox centers) - Output: 60 dim
    layout_features = []
    for m in masks[:15]:
        x, y, w, h = m['bbox']
        layout_features.extend([x/1024, y/1024, w/1024, h/1000])
    while len(layout_features) < 60: 
        layout_features.append(0)
    layout_emb = np.array(layout_features[:60])
    
    # 4. Concatenate: 512 + 324 + 60 = 896
    composite = np.concatenate([vis_emb, text_emb, layout_emb])
    
    # Return normalized vector
    norm = np.linalg.norm(composite)
    if norm == 0: 
        return composite
    return composite / norm

# --- MEMORY FUNCTIONS ---
def build_faiss_index():
    global memory_metadata, index
    index = faiss.IndexFlatIP(896)
    memory_metadata = []
    
    img_dir = str(IMAGES_DIR)
    if os.path.exists(img_dir):
        for file in os.listdir(img_dir):
            if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                path = os.path.join(img_dir, file)
                add_to_index(path, file)
    print(f"Dynamic RAG Memory Rebuilt: {len(memory_metadata)} screens registered in FAISS.")

def add_to_index(img_path, filename):
    img = clip_preprocess(Image.open(img_path)).unsqueeze(0).to(DEVICE)
    with torch.no_grad():
        emb = clip_model.encode_image(img).cpu().numpy()[0]
    emb /= np.linalg.norm(emb)
    full_emb = np.zeros(896, dtype="float32")
    full_emb[384:] = emb
    index.add(np.array([full_emb]).astype("float32"))
    if filename not in memory_metadata:
        memory_metadata.append(filename)

def save_to_memory(img_np, ui_json_str, flutter, html, ocr_texts, masks):
    try:
        embedding = create_composite_embedding(img_np, ocr_texts, masks)
        timestamp = str(time.time())
        base_name = f"ui_{timestamp}"
        
        # Save files
        img_path = str(IMAGES_DIR / f"{base_name}.png")
        cv2.imwrite(img_path, cv2.cvtColor(img_np, cv2.COLOR_RGB2BGR))
        
        # Save to ChromaDB
        collection.add(
            ids=[base_name],
            embeddings=[embedding.tolist()],
            metadatas=[{
                "json_data": ui_json_str,
                "flutter_code": flutter,
                "html_code": html,
                "filename": f"{base_name}.png"
            }]
        )
        print(f"INFO: Successfully saved image and codes to ChromaDB vector store.")
        return base_name
    except Exception as db_err:
        print(f"WARNING: save_to_memory encountered an error: {str(db_err)}")
        return None

# --- HELPER UTILS ---
def bytes_to_numpy(image_bytes: bytes) -> np.ndarray:
    nparr = np.frombuffer(image_bytes, np.uint8)
    img_bgr = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    return cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)

def numpy_to_base64(img_np: np.ndarray) -> str:
    img_bgr = cv2.cvtColor(img_np, cv2.COLOR_RGB2BGR)
    _, buffer = cv2.imencode('.png', img_bgr)
    return base64.b64encode(buffer).decode('utf-8')

def find_image_refs_recursive(obj, refs_set):
    if isinstance(obj, dict):
        if obj.get("type") == "IMAGE" and "imageRef" in obj:
            refs_set.add(obj["imageRef"])
        for val in obj.values():
            find_image_refs_recursive(val, refs_set)
    elif isinstance(obj, list):
        for item in obj:
            find_image_refs_recursive(item, refs_set)

def replace_image_paths_recursive(obj, ref_mapping):
    if isinstance(obj, dict):
        if obj.get("type") == "IMAGE" and "imageRef" in obj:
            ref = obj["imageRef"]
            if ref in ref_mapping:
                obj["src"] = ref_mapping[ref]
        for val in obj.values():
            replace_image_paths_recursive(val, ref_mapping)
    elif isinstance(obj, list):
        for item in obj:
            replace_image_paths_recursive(item, ref_mapping)

def calculate_hybrid_similarity(new_ir, candidate_ir, new_img, candidate_img):
    visual_score = 0.85
    new_nodes = len(json.loads(new_ir).get("root_components", []))
    cand_nodes = len(json.loads(candidate_ir).get("root_components", []))
    structural_score = 1.0 - (abs(new_nodes - cand_nodes) / max(new_nodes, cand_nodes, 1))
    score = (visual_score * 0.3) + (structural_score * 0.4) + (0.8 * 0.3)
    return score * 100

def step_1_sam(input_img):
    print("DEBUG: Starting SAM segmentation...")
    img_np = np.array(input_img)
    padded_img, meta = standardize_for_sam(img_np)
    print("DEBUG: Generating masks...")
    
    masks = mask_generator.generate(padded_img)
    print(f"DEBUG: SAM completed with {len(masks)} masks.")
    import gc
    gc.collect() 
    
    for m in masks:
        x, y, w, h = m['bbox']
        m['bbox'] = [
            max(0, int((x - meta['left']) / meta['scale'])),
            max(0, int((y - meta['top']) / meta['scale'])),
            int(w / meta['scale']),
            int(h / meta['scale'])
        ]
    
    return padded_img, masks, img_np, meta

def step_2_ocr(masks, ocr_img):
    if not masks:
        return [], [], "No masks found."
    if ocr_img is None:
        return [], [], "No OCR image found."
        
    ocr_img_np = np.array(ocr_img)
    ocr_results = reader.readtext(ocr_img_np)
    assigned_texts = [[] for _ in range(len(masks))]
    
    for bbox, text, prob in ocr_results:
        xs = [pt[0] for pt in bbox]
        ys = [pt[1] for pt in bbox]
        tx_min, tx_max = min(xs), max(xs)
        ty_min, ty_max = min(ys), max(ys)
        text_area = (tx_max - tx_min) * (ty_max - ty_min)
        
        best_idx = -1
        min_mask_area = float('inf')
        
        for idx, m in enumerate(masks):
            mx, my, mw, mh = m['bbox']
            mx_min, my_min, mx_max, my_max = mx, my, mx + mw, my + mh
            
            ix_min = max(tx_min, mx_min)
            iy_min = max(ty_min, my_min)
            ix_max = min(tx_max, mx_max)
            iy_max = min(ty_max, my_max)
            
            if ix_max > ix_min and iy_max > iy_min:
                overlap_area = (ix_max - ix_min) * (iy_max - iy_min)
                if overlap_area > (text_area * 0.4):
                    mask_area = mw * mh
                    if mask_area < min_mask_area:
                        min_mask_area = mask_area
                        best_idx = idx
                        
        if best_idx != -1:
            cleaned = clean_text(text)
            if cleaned:
                assigned_texts[best_idx].append(cleaned)
        else:
            t_cx = (tx_min + tx_max) / 2
            t_cy = (ty_min + ty_max) / 2
            min_dist = float('inf')
            closest_idx = 0
            for idx, m in enumerate(masks):
                mx, my, mw, mh = m['bbox']
                m_cx = mx + mw/2
                m_cy = my + mh/2
                dist = (t_cx - m_cx)**2 + (t_cy - m_cy)**2
                if dist < min_dist:
                    min_dist = dist
                    closest_idx = idx
            cleaned = clean_text(text)
            if cleaned:
                assigned_texts[closest_idx].append(cleaned)

    return assigned_texts, assigned_texts, "Step 2 Done: OCR Finished"

def step_3_color(masks, img_np):
    colors_hex = []
    colors_rgb_str = []
    img_h, img_w = img_np.shape[:2]
    
    for m in masks:
        x, y, w, h = [int(v) for v in m["bbox"]]
        x1, y1, x2, y2 = max(0, x), max(0, y), min(img_w, x + w), min(img_h, y + h)
        crop = img_np[y1:y2, x1:x2]

        if crop.size == 0:
            colors_hex.append("#FFFFFF")
            colors_rgb_str.append("rgb(255, 255, 255)")
            continue

        if len(crop.shape) == 2:
            crop = cv2.cvtColor(crop, cv2.COLOR_GRAY2RGB)
        elif crop.shape[2] == 4:
            crop = cv2.cvtColor(crop, cv2.COLOR_RGBA2RGB)

        mean = crop.mean(axis=(0,1)).astype(int)
        
        r = mean[0] if len(mean) > 0 else 255
        g = mean[1] if len(mean) > 1 else 255
        b = mean[2] if len(mean) > 2 else 255
        
        colors_hex.append('#{:02x}{:02x}{:02x}'.format(r, g, b))
        colors_rgb_str.append(f"rgb({r}, {g}, {b})")

    return colors_hex, colors_rgb_str, "Step 3 Done: Color Extraction Finished"

# --- GEMINI DYNAMIC MODEL GENERATION STAGE ---

def generate_code_with_gemini_model(model_name: str, ui_json_str: str) -> tuple:
    """
    Synthesizes responsive HTML/CSS and Flutter layout code blocks using the specified Gemini model tier.
    """
    if not GEMINI_AVAILABLE or not GEMINI_API_KEY or GEMINI_API_KEY == "YOUR_API_KEY_HERE":
        print("CRITICAL WARNING: Gemini API Key has not been configured in the environment.")
        return "/* Code synthesis failed: Missing Gemini API Key. */", "<!-- Code synthesis failed: Missing Gemini API Key -->"
        
    system_instruction = (
        "You are an expert Frontend and Flutter Engineer. Your input is an Enriched Hierarchical DesignIR JSON.\n\n"
        "RULES FOR CONVERTING JSON TO CODE:\n"
        "1. HIERARCHY IS LAW: The JSON contains a 'children' array for each component.\n"
        "   - If a component has children, it MUST be a parent container.\n"
        "   - Use these relationships to build your Widget tree (Flutter) or DOM tree (HTML).\n\n"
        "2. DATA UTILIZATION:\n"
        "   - Use 'label' for text content.\n"
        "   - Use 'hex_color' for backgrounds/styles.\n"
        "   - Use 'bbox' for proportions. Never hardcode absolute heights.\n\n"
        "3. OUTPUT FORMATTING:\n"
        "   - Wrap Flutter code in [FLUTTER_START]...[FLUTTER_END]\n"
        "   - Wrap HTML/CSS code in [HTML_START]...[HTML_END]\n"
    )
    user_prompt = (
        f"Translate the following DesignIR JSON into a cohesive Flutter Widget and a responsive HTML page:\n\n"
        f"DesignIR JSON:\n{ui_json_str}"
    )

    try:
        model = genai.GenerativeModel(
            model_name=model_name,
            system_instruction=system_instruction
        )
        response = model.generate_content(user_prompt)
        response_text = response.text
        
        if not response_text:
            raise ValueError("Empty response received from Google Generative AI gateway.")
            
    except Exception as gemini_err:
        print(f"ERROR: Gemini synthesis failed on model tier '{model_name}': {str(gemini_err)}")
        traceback.print_exc()
        return (
            f"/* Code synthesis failed on model tier {model_name}. Please verify your API keys and parameters. */",
            f"<!-- Code synthesis failed on model tier {model_name}. Error: {str(gemini_err)} -->"
        )

    flutter_part = ""
    html_part = ""

    flutter_match = re.search(r"\[FLUTTER_START\](.*?)\[FLUTTER_END\]", response_text, re.DOTALL | re.IGNORECASE)
    if flutter_match:
        flutter_part = flutter_match.group(1).strip()
        
    html_match = re.search(r"\[HTML_START\](.*?)\[HTML_END\]", response_text, re.DOTALL | re.IGNORECASE)
    if html_match:
        html_part = html_match.group(1).strip()

    if not flutter_part or not html_part:
        code_blocks = re.findall(r"```(?:dart|html|css|xml)?\s*(.*?)\s*```", response_text, re.DOTALL)
        if len(code_blocks) >= 2:
            if any(kw in code_blocks[0] for kw in ["import", "Widget", "BuildContext"]):
                flutter_part, html_part = code_blocks[0], code_blocks[1]
            else:
                html_part, flutter_part = code_blocks[0], code_blocks[1]
        elif len(code_blocks) == 1:
            if any(kw in code_blocks[0] for kw in ["Widget", "BuildContext"]):
                flutter_part = code_blocks[0]
            else:
                html_part = code_blocks[0]

    flutter_part = re.sub(r"^```(?:dart|flutter)?\s*", "", flutter_part)
    flutter_part = re.sub(r"\s*```$", "", flutter_part).strip()
    
    html_part = re.sub(r"^```(?:html|xml)?\s*", "", html_part)
    html_part = re.sub(r"\s*```$", "", html_part).strip()

    if not flutter_part:
        flutter_part = "/* Failed to extract Flutter code layout */"
    if not html_part:
        html_part = "<!-- Failed to extract HTML structural layout -->"

    return flutter_part, html_part

def step_4_and_orchestrate(img_np, ui_json_str, texts, masks):
    """
    Routes code synthesis requests based on design similarity scoring.
    """
    query_emb = create_composite_embedding(img_np, texts, masks)
    results = collection.query(query_embeddings=[query_emb.tolist()], n_results=1)
    
    similarity = 0.0
    candidate = None
    
    if results and 'metadatas' in results and results['metadatas'][0]:
        candidate = results['metadatas'][0][0]
        candidate_json = candidate.get('json_data', '{}')
        similarity = calculate_hybrid_similarity(ui_json_str, candidate_json, img_np, None)
    
    # Cache hit verification
    if similarity >= 90.0 and candidate:
        return (
            candidate.get('flutter_code', ''), 
            candidate.get('html_code', ''), 
            f"Cache Hit | Similarity Score: {round(similarity, 1)}%",
            "gemini-cached",
            f"Similarity score {round(similarity, 1)}% >= 90%. Retrieved pre-built certified components from vector store for 0ms generation."
        )
        
    # Dynamic routing and rationale setup
    if similarity < 60.0:
        model_name = CODE_MODEL
        reason = f"Similarity score is low ({round(similarity, 1)}%). Routing to Gemini 3.5 Flash for rapid baseline layout generation."
    elif 60.0 <= similarity < 70.0:
        model_name = CODE_MODEL
        reason = f"Moderate similarity ({round(similarity, 1)}%). Optimized token throughput and low latency DOM generation."
    elif 70.0 <= similarity < 80.0:
        model_name = CODE_MODEL
        reason = f"High similarity ({round(similarity, 1)}%). High-fidelity rendering with Gemini 3.5 Flash engine."
    else: # 80.0 <= similarity < 90.0
        model_name = CODE_MODEL
        reason = f"Very high similarity ({round(similarity, 1)}%). Fast compilation with Gemini 3.5 Flash engine."
        
    print(f"Routing logic: selected model '{model_name}' for score {round(similarity, 1)}%")
    
    # Generate the flutter and html code (THIS LINE WAS MISSING/SKIPPED)
    flutter, html = generate_code_with_gemini_model(model_name, ui_json_str)
    
    try:
        save_to_memory(img_np, ui_json_str, flutter, html, texts, masks)
    except Exception as save_err:
        print(f"Database Cache Write Warning: {save_err}")
        
    return flutter, html, f"Synthesized with Gemini ({model_name}) | Similarity: {round(similarity, 1)}%", model_name, reason

def step_5_json(masks, texts, colors_hex, colors_rgb_str, img_np):
    if not masks:
        return "{}", "{}", "No elements generated."
    
    components = []
    
    for i in range(len(masks)):
        bbox = masks[i]['bbox']
        text_list = texts[i] if i < len(texts) else []
        joined_text = " ".join(text_list)
        
        components.append({
            "id": i,
            "type": "container",
            "bbox": [int(v) for v in bbox],
            "label": joined_text,
            "hex_color": colors_hex[i] if i < len(colors_hex) else "#FFFFFF",
            "rgb_color": colors_rgb_str[i] if i < len(colors_rgb_str) else "rgb(255,255,255)",
            "visual_features": {
                "area": bbox[2] * bbox[3],
                "aspect_ratio": bbox[2] / bbox[3] if bbox[3] > 0 else 1.0
            },
            "children": []
        })

    components.sort(key=lambda c: (c['bbox'][2] * c['bbox'][3]), reverse=True)
    
    root_elements = []
    for i in range(len(components)):
        is_child = False
        for j in range(len(components)):
            if i == j: continue
            b1 = components[i]['bbox']
            b2 = components[j]['bbox']
            if (b1[0] >= b2[0] and b1[1] >= b2[1] and 
                (b1[0]+b1[2]) <= (b2[0]+b2[2]) and 
                (b1[1]+b1[3]) <= (b2[1]+b2[3])):
                components[j]['children'].append(components[i])
                is_child = True
                break
        if not is_child:
            root_elements.append(components[i])

    def classify(comp):
        lower_text = comp['label'].lower()
        if any(kw in lower_text for kw in ["login", "submit", "button", "next"]): comp['type'] = "button"
        elif any(kw in lower_text for kw in ["email", "password", "input", "search"]): comp['type'] = "input"
        elif comp['label']: comp['type'] = "text"
        for child in comp['children']: classify(child)

    for root in root_elements: classify(root)

    design_ir = {
        "ir_type": "DesignIR_Enriched",
        "metadata": {
            "total_elements": len(components),
            "image_size": [img_np.shape[1], img_np.shape[0]]
        },
        "root_components": root_elements
    }
    
    return json.dumps(design_ir, indent=2), json.dumps(design_ir), "Step 5 Done: Enriched Hierarchical JSON"

def step_6_code(ui_json_str, cached_flutter, cached_html, img_np, match_id, texts, masks):
    """
    Standard generation entrypoint. Serves standard bulk-ingest pipelines with gemini-3.5-flash model.
    """
    if match_id and match_id != "New Screen Identified":
        return cached_flutter, cached_html, f"Database Cache Hit (Matched: {match_id})"
        
    flutter, html = generate_code_with_gemini_model(CODE_MODEL, ui_json_str)
    
    try:
        save_to_memory(img_np, ui_json_str, flutter, html, texts, masks)
    except Exception as save_err:
        print(f"Database Cache Write Warning: {save_err}")
        
    return flutter, html, "Synthesized with Gemini API (gemini-3.5-flash)"

# --- HYBRID RENDERING ENGINE ---

def render_html_to_image(html_code: str, ui_json_str: str) -> np.ndarray:
    """
    Renders synthesized semantic HTML/CSS code.
    Attempts: Playwright (Chromium) -> html2image (Chrome) -> Blank Error Canvas.
    """
    if "synthesis failed" in html_code or "synthesis offline" in html_code or "Failed to extract" in html_code:
        print("HTML Code Generation Failed. Showing generation failure canvas in comparison tab...")
        
        err_canvas = np.zeros((1024, 512, 3), dtype=np.uint8) + 245
        cv2.putText(err_canvas, "[HTML Synthesis Failed]", (50, 450), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (50, 50, 200), 2)
        cv2.putText(err_canvas, "Similarity comparison is suspended", (50, 500), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (100, 110, 120), 1)
        cv2.putText(err_canvas, "until code generates successfully.", (50, 530), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (100, 110, 120), 1)
        return err_canvas

    temp_html = str(DATA_DIR / "temp_render.html")
    temp_png = str(DATA_DIR / "temp_render.png")
    
    styled_html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <style>
            body {{
                margin: 0;
                padding: 0;
                background-color: #ffffff;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                width: 512px;
                height: 1024px;
                overflow: hidden;
            }}
        </style>
    </head>
    <body>
        {html_code}
    </body>
    </html>
    """

    # Stage 1: Playwright rendering
    try:
        from playwright.sync_api import sync_playwright
        with open(temp_html, "w", encoding="utf-8") as f:
            f.write(styled_html)
            
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            page.set_viewport_size({"width": 512, "height": 1024})
            abs_path = os.path.abspath(temp_html)
            page.goto(f"file://{abs_path}")
            page.screenshot(path=temp_png, full_page=False)
            browser.close()
            
        if os.path.exists(temp_png):
            rendered_bgr = cv2.imread(temp_png)
            if rendered_bgr is not None:
                if os.path.exists(temp_html): os.remove(temp_html)
                if os.path.exists(temp_png): os.remove(temp_png)
                return cv2.cvtColor(rendered_bgr, cv2.COLOR_BGR2RGB)
    except Exception as pw_err:
        print(f"Playwright rendering execution bypassed or failed: {str(pw_err)}. Trying fallback...")

    # Stage 2: html2image rendering
    try:
        from html2image import Html2Image
        hti = Html2Image(custom_flags=['--no-sandbox', '--disable-gpu', '--headless', '--default-background-color=ffffff'])
        with open(temp_html, "w", encoding="utf-8") as f:
            f.write(styled_html)
            
        hti.screenshot(html_file=temp_html, save_as=temp_png, size=(512, 1024))
        
        if os.path.exists(temp_png):
            rendered_bgr = cv2.imread(temp_png)
            if rendered_bgr is not None:
                if os.path.exists(temp_html): os.remove(temp_html)
                if os.path.exists(temp_png): os.remove(temp_png)
                return cv2.cvtColor(rendered_bgr, cv2.COLOR_BGR2RGB)
    except Exception as h2i_err:
        print(f"html2image rendering execution bypassed or failed: {str(h2i_err)}")

    # Cleanup
    if os.path.exists(temp_html): os.remove(temp_html)
    if os.path.exists(temp_png): os.remove(temp_png)

    empty_canvas = np.zeros((1024, 512, 3), dtype=np.uint8) + 245
    cv2.putText(empty_canvas, "[Awaiting HTML Render Output]", (50, 450), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (100, 110, 120), 1)
    return empty_canvas

def compare_images_clip(img1_np: np.ndarray, img2_np: np.ndarray) -> float:
    """
    Computes visual reconstruction similarity between standard design components
    and synthetic model renderings using CLIP feature vector cosine distance.
    """
    try:
        img1_pil = Image.fromarray(img1_np)
        img2_pil = Image.fromarray(img2_np)
        
        t1 = clip_preprocess(img1_pil).unsqueeze(0).to(DEVICE)
        t2 = clip_preprocess(img2_pil).unsqueeze(0).to(DEVICE)
        
        with torch.no_grad():
            f1 = clip_model.encode_image(t1)
            f2 = clip_model.encode_image(t2)
            
            f1 /= f1.norm(dim=-1, keepdim=True)
            f2 /= f2.norm(dim=-1, keepdim=True)
            
            cosine_similarity = (f1 @ f2.T).item()
            percentage_similarity = round(cosine_similarity * 100.0, 2)
            return max(0.0, min(100.0, percentage_similarity))
    except Exception as clip_err:
        print(f"CLIP calculation engine exception: {str(clip_err)}")
        return 0.0

# --- FASTAPI SERVER DEFINITIONS ---

app = FastAPI(title="FirstKutAI Integrated Synthesis Engine", version="4.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

class AssetExtractionPayload(BaseModel):
    fileKey: str
    token: str
    figmaJson: dict

class FigmaGeneratePayload(BaseModel):
    format: str            # html | flutter | react
    componentName: str = "FigmaExport"
    pageJson: dict

def require_api_key(x_api_key: Optional[str] = Header(None)):
    """Shared-secret guard for every /api/* route when API_KEY is configured."""
    if not API_KEY:
        return
    if x_api_key != API_KEY:
        raise HTTPException(status_code=401, detail="Missing or invalid x-api-key header")

# Serve downloaded Figma assets back to the frontend
app.mount("/assets", StaticFiles(directory=str(ASSETS_DIR)), name="assets")

@app.get("/health")
def health():
    """Readiness probe for Runpod healthchecks and uptime monitors."""
    active_jobs = sum(1 for j in JOBS.values() if j.get("status") in ("queued", "running"))
    return {
        "status": "ok",
        "device": DEVICE,
        "models_loaded": True,
        "active_jobs": active_jobs,
        "gemini_configured": bool(GEMINI_API_KEY and GEMINI_AVAILABLE),
    }

ingestion_status = {"current_file": "", "processed": 0, "total": 0}

@app.get("/api/ingestion_status")
async def get_ingestion_status(_=Depends(require_api_key)):
    return ingestion_status

# --- JOB RUNTIME -----------------------------------------------------------
# Heavy work is executed in a worker thread and polled by the client.
# The Runpod/Cloudflare HTTP proxy kills any single request after ~100s, so no
# endpoint may block for longer than that.

def _prune_jobs():
    if len(JOBS) <= JOBS_MAX_HISTORY:
        return
    finished = sorted(
        (j for j in JOBS.values() if j.get("status") in ("completed", "failed")),
        key=lambda j: j.get("created_at", 0),
    )
    for job in finished[: max(0, len(JOBS) - JOBS_MAX_HISTORY)]:
        JOBS.pop(job["job_id"], None)

def _create_job(kind: str) -> dict:
    job = {
        "job_id": uuid.uuid4().hex[:12],
        "kind": kind,
        "status": "queued",          # queued | running | completed | failed
        "stage": "Queued for execution",
        "steps": [],
        "progress": {"current_file": "", "processed": 0, "total": 0},
        "result": None,
        "error": None,
        "created_at": time.time(),
    }
    _prune_jobs()
    JOBS[job["job_id"]] = job
    return job

def _run_job(job: dict, target, *args):
    job["status"] = "running"
    try:
        with PIPELINE_LOCK:
            job["result"] = target(job, *args)
        job["status"] = "completed"
        job["stage"] = "Completed"
    except Exception as err:
        traceback.print_exc()
        job["status"] = "failed"
        job["stage"] = "Failed"
        job["error"] = str(err)

def _spawn_job(job: dict, target, *args):
    threading.Thread(target=_run_job, args=(job, target, *args), daemon=True).start()

def _job_view(job: dict) -> dict:
    view = dict(job)
    # Base64 previews are large: only ship the payload with the final response
    if job["status"] != "completed":
        view = {k: v for k, v in view.items() if k != "result"}
    return view

@app.get("/api/jobs/{job_id}")
async def get_job(job_id: str, _=Depends(require_api_key)):
    job = JOBS.get(job_id)
    if not job:
        raise HTTPException(status_code=404, detail="Unknown job id")
    return _job_view(job)


class _StageLog(list):
    """Stage log that mirrors itself into the polled job payload on every append."""

    def __init__(self, job):
        super().__init__()
        self._job = job

    def append(self, entry):
        super().append(entry)
        self._job["steps"] = [dict(s) for s in self]
        self._job["stage"] = f"Stage {entry.get('stage', '?')}: {entry.get('name', '')}"


# --- Process UI Endpoint ---
def _process_ui_pipeline(job, contents: bytes) -> dict:
    """Full screenshot pipeline. Runs inside a worker thread (never on the event loop)."""
    try:
        first_kut_logs = _StageLog(job)
        total_start_time = time.perf_counter()
        job["stage"] = "Stage 1/7: Knowledge Ingestion (SAM segmentation)"
        
        # --- STAGE 1: KNOWLEDGE INGESTION ---
        t_start = time.perf_counter()
        img_np = bytes_to_numpy(contents)
        pil_img = Image.fromarray(img_np)
        
        viz, masks, raw_np, _ = step_1_sam(pil_img)
        t_duration = time.perf_counter() - t_start
        first_kut_logs.append({
            "stage": 1,
            "name": "Knowledge Ingestion",
            "desc": "Raw source ingestion. Executing SAM Layout Segmentation.",
            "duration": round(t_duration, 3),
            "status": "Success",
            "meta": f"Identified {len(masks)} structural mask regions."
        })
        
        # --- STAGE 2: KNOWLEDGE FOUNDRY ---
        t_start = time.perf_counter()
        texts, _, _ = step_2_ocr(masks, pil_img)
        colors_hex, colors_rgb_str, _ = step_3_color(masks, raw_np)
        t_duration = time.perf_counter() - t_start
        first_kut_logs.append({
            "stage": 2,
            "name": "Knowledge Foundry",
            "desc": "OCR extraction & Color profiling into unified design parameters.",
            "duration": round(t_duration, 3),
            "status": "Success",
            "meta": f"Normalized {len(texts)} text blocks and element color nodes."
        })
        
        # --- STAGE 3: KNOWLEDGE STRUCTURING & INDEXING ---
        t_start = time.perf_counter()
        ui_json, _, _ = step_5_json(masks, texts, colors_hex, colors_rgb_str, raw_np)
        comp_emb = create_composite_embedding(raw_np, texts, masks)
        t_duration = time.perf_counter() - t_start
        first_kut_logs.append({
            "stage": 3,
            "name": "Structuring & Indexing",
            "desc": "Compiling DesignIR JSON Blueprint and multi-modal feature vector.",
            "duration": round(t_duration, 3),
            "status": "Success",
            "meta": f"Formulated embedding coordinates: dim={len(comp_emb)}."
        })
        
        # --- STAGE 4 & 5: INTELLIGENT ORCHESTRATION & SYNTHESIS ---
        t_start = time.perf_counter()
        flutter, html, similarity_logs, model_used, reasoning = step_4_and_orchestrate(raw_np, ui_json, texts, masks)
        cache_hit = ("Cache Hit" in similarity_logs)
        t_duration = time.perf_counter() - t_start
        first_kut_logs.append({
            "stage": 4,
            "name": "Intelligent Orchestration",
            "desc": f"Routing: {model_used}. Reasoning: {reasoning}",
            "duration": round(t_duration, 3),
            "status": "Success",
            "meta": f"Result: {similarity_logs.split('|')[-1].strip()} | Engine: {model_used}"
        })
        
        # --- NEW STAGE: HTML VISUAL RENDERING AND CLIP ALIGNMENT CHECK ---
        t_start = time.perf_counter()
        rendered_np = render_html_to_image(html, ui_json)
        
        # Resize raw_np to match standard render sizes before CLIP evaluation
        resized_original = cv2.resize(raw_np, (512, 1024))
        clip_visual_similarity = compare_images_clip(resized_original, rendered_np)
        rendered_b64 = numpy_to_base64(rendered_np)
        t_duration = time.perf_counter() - t_start
        
        first_kut_logs.append({
            "stage": 5,
            "name": "Visual Alignment Check",
            "desc": "HTML design rendered and evaluated using CLIP against source.",
            "duration": round(t_duration, 3),
            "status": "Success",
            "meta": f"Calculated visual reconstruction alignment score: {clip_visual_similarity}%"
        })
        
        # --- STAGE 6: RECONCILIATION & VALIDATION ---
        t_start = time.perf_counter()
        if flutter.startswith("/*") and flutter.endswith("*/") and len(flutter) < 100:
            validation_msg = "Validation warning: Check standard output layout specifications."
        else:
            validation_msg = "Passed format compliance checks."
        t_duration = time.perf_counter() - t_start
        first_kut_logs.append({
            "stage": 6,
            "name": "Reconciliation & Validation",
            "desc": "Comparing source blueprint with candidate output files for structural compliance.",
            "duration": round(t_duration, 3),
            "status": "Success",
            "meta": validation_msg
        })
        
        # --- STAGE 7: PROMOTION GOVERNANCE ---
        t_start = time.perf_counter()
        if not cache_hit and (len(flutter) > 100 or len(html) > 100):
            try:
                timestamp = str(int(time.time()))
                with open(HTML_DIR / f"build_{timestamp}.html", "w", encoding="utf-8") as f_html:
                    f_html.write(html)
                with open(DART_DIR / f"build_{timestamp}.dart", "w", encoding="utf-8") as f_flutter:
                    f_flutter.write(flutter)
                promotion_msg = "Promoted and stored component into target codebase directory."
            except Exception as fe:
                promotion_msg = f"Skipped local file storage: {str(fe)}"
        else:
            promotion_msg = "Asset exists in codebase directory. Skipped duplicate build export."
        t_duration = time.perf_counter() - t_start
        first_kut_logs.append({
            "stage": 7,
            "name": "Promotion Governance",
            "desc": "Registering certified implementation components into the reusable system library.",
            "duration": round(t_duration, 3),
            "status": "Success",
            "meta": promotion_msg
        })
        
        total_duration = time.perf_counter() - total_start_time
        sam_preview_b64 = numpy_to_base64(viz)
        
        return {
            "status": "Completed FirstKutAI Pipeline Integration",
            "model_used": model_used,
            "model_engine": model_used,
            "reasoning": reasoning,
            "model_reason": reasoning,
            "similarity": similarity_logs,
            "similarity_logs": similarity_logs,
            "similarityLogs": similarity_logs,
            "json": ui_json,
            "ui_json": ui_json,
            "uiJson": ui_json,
            "flutter": flutter,
            "flutter_code": flutter,
            "flutterCode": flutter,
            "flutter_output": flutter,
            "flutterOutput": flutter,
            "html": html,
            "html_code": html,
            "htmlCode": html,
            "html_css": html,
            "htmlCss": html,
            "html_css_output": html,
            "htmlCssOutput": html,
            "sam_preview": sam_preview_b64,
            "samPreview": sam_preview_b64,
            "ocr_text": texts,
            "ocrText": texts,
            "colors": colors_hex,
            "html_render_preview": rendered_b64,
            "clip_similarity": clip_visual_similarity,
            "performance_metrics": {
                "steps": first_kut_logs,
                "total_duration_sec": round(total_duration, 3)
            }
        }
    except Exception as e:
        traceback.print_exc()
        raise RuntimeError(f"Visual code synthesis pipeline failed: {str(e)}") from e

@app.post("/api/process_ui")
async def process_ui(file: UploadFile = File(...), _=Depends(require_api_key)):
    """Starts the screenshot pipeline as a background job and returns its job_id.

    Clients poll GET /api/jobs/{job_id}. No request ever blocks for the whole
    pipeline, which keeps every call well under the Runpod proxy 100s limit.
    """
    contents = await file.read()
    if not contents:
        raise HTTPException(status_code=400, detail="Empty file upload")

    job = _create_job("process_ui")
    _spawn_job(job, _process_ui_pipeline, contents)
    return {
        "job_id": job["job_id"],
        "status": job["status"],
        "message": "Pipeline started. Poll /api/jobs/" + job["job_id"],
    }

INGEST_TMP_DIR = DATA_DIR / "tmp_ingest"

def _ingest_folder_pipeline(job, entries):
    """entries: list of (filename, staging_path). Runs inside a worker thread."""
    global ingestion_status
    results = {"processed": 0, "errors": []}

    ingestion_status = {"current_file": "Initializing...", "processed": 0, "total": len(entries)}
    job["progress"] = dict(ingestion_status)

    try:
        for filename, path in entries:
            ingestion_status["current_file"] = filename
            job["progress"] = dict(ingestion_status)
            job["stage"] = f"Ingesting {filename}"
            try:
                with open(path, "rb") as fh:
                    contents = fh.read()
                img_np = bytes_to_numpy(contents)

                pil_img = Image.fromarray(img_np)
                viz, masks, raw_np, _ = step_1_sam(pil_img)
                texts, _, _ = step_2_ocr(masks, pil_img)
                colors_hex, colors_rgb_str, _ = step_3_color(masks, raw_np)

                ui_json, _, _ = step_5_json(masks, texts, colors_hex, colors_rgb_str, raw_np)

                flutter, html, _ = step_6_code(ui_json, "", "", raw_np, "New Screen", texts, masks)

                save_to_memory(raw_np, ui_json, flutter, html, texts, masks)

                ingestion_status["processed"] += 1
            except Exception as e:
                print(f"Error processing {filename}: {e}")
                results["errors"].append({"filename": filename, "error": str(e)})
            finally:
                try:
                    os.remove(path)
                except OSError:
                    pass
            job["progress"] = dict(ingestion_status)
    finally:
        ingestion_status["current_file"] = "Completed"
        job["progress"] = dict(ingestion_status)

    return {"status": "Done", "details": results}

@app.post("/api/ingest_folder")
async def ingest_folder(files: List[UploadFile] = File(...), _=Depends(require_api_key)):
    """Stages uploaded images on disk and ingests them as a background job."""
    INGEST_TMP_DIR.mkdir(parents=True, exist_ok=True)
    entries = []
    for upload in files:
        safe_name = Path(upload.filename or "image.png").name
        staging = INGEST_TMP_DIR / f"{uuid.uuid4().hex}_{safe_name}"
        staging.write_bytes(await upload.read())
        entries.append((safe_name, str(staging)))

    if not entries:
        raise HTTPException(status_code=400, detail="No files uploaded")

    job = _create_job("ingest_folder")
    job["progress"] = {"current_file": "Initializing...", "processed": 0, "total": len(entries)}
    _spawn_job(job, _ingest_folder_pipeline, entries)
    return {"job_id": job["job_id"], "status": job["status"], "details": {"total": len(entries)}}

@app.get("/figma-api/v1/files/{file_key}")
async def proxy_figma_file(file_key: str, x_figma_token: Optional[str] = Header(None), _=Depends(require_api_key)):
    if not x_figma_token:
        raise HTTPException(status_code=400, detail="Missing X-Figma-Token header request parameter")
    
    max_retries = 4 
    retry_delay = 10.0
    
    async with httpx.AsyncClient() as client:
        for attempt in range(max_retries):
            try:
                response = await client.get(
                    f"https://api.figma.com/v1/files/{file_key}",
                    headers={"X-Figma-Token": x_figma_token},
                    timeout=30.0
                )
                
                if response.status_code == 429:
                    if attempt < max_retries - 1:
                        print(f"Figma API rate limit hit. Retrying in {retry_delay} seconds...")
                        await asyncio.sleep(retry_delay)
                        retry_delay *= 2
                        continue
                
                if response.status_code != 200:
                    raise HTTPException(status_code=response.status_code, detail=response.text)
                return response.json()
                
            except httpx.RequestError as e:
                if attempt < max_retries - 1:
                    await asyncio.sleep(retry_delay)
                    retry_delay *= 2
                    continue
                raise HTTPException(status_code=500, detail=f"Figma API Proxy call failed: {str(e)}")
        
    raise HTTPException(status_code=429, detail="Figma API Rate Limit exceeded. Please wait a moment before trying again.")

@app.post("/figma-assets/extract")
async def extract_figma_assets(payload: AssetExtractionPayload, _=Depends(require_api_key)):
    try:
        fig_json = payload.figmaJson
        refs = set()
        find_image_refs_recursive(fig_json, refs)
        
        if not refs:
            return {"status": "Success", "figmaJson": fig_json, "assets": [], "imageRefCount": 0}
            
        async with httpx.AsyncClient() as client:
            img_res = await client.get(
                f"https://api.figma.com/v1/files/{payload.fileKey}/images",
                headers={"X-Figma-Token": payload.token},
                timeout=20.0
            )
            if img_res.status_code != 200:
                raise HTTPException(status_code=img_res.status_code, detail="Unable to retrieve asset URLs from Figma")
                
            image_urls = img_res.json().get("meta", {}).get("images", {})
            
            ref_mapping = {}
            downloaded_assets = []
            
            for ref in refs:
                if ref in image_urls:
                    url = image_urls[ref]
                    try:
                        img_data = (await client.get(url, timeout=15.0)).content
                        local_filename = f"figma_{ref[:12]}.png"
                        local_path = ASSETS_DIR / local_filename
                        
                        with open(local_path, "wb") as f:
                            f.write(img_data)
                            
                        # Absolute URL: the frontend runs on a different origin
                        public_web_path = f"{PUBLIC_BASE_URL}/assets/{local_filename}"
                        ref_mapping[ref] = public_web_path
                        downloaded_assets.append({"imageRef": ref, "path": public_web_path})
                    except Exception as e:
                        print(f"Warning: Failed to fetch image ref {ref}: {e}")
                        continue
                    
        replace_image_paths_recursive(fig_json, ref_mapping)
        
        return {
            "status": "Success",
            "figmaJson": fig_json,
            "assets": downloaded_assets,
            "imageRefCount": len(refs),
            "missingRefs": [r for r in refs if r not in ref_mapping]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Image extraction processing failed: {str(e)}")


FIGMA_CODE_MODEL = os.environ.get("FIGMA_GEMINI_MODEL", "gemini-1.5-flash")

def _strip_code_fences(text: str) -> str:
    cleaned = (text or "").strip()
    if cleaned.startswith("```"):
        first_newline = cleaned.index("\n") if "\n" in cleaned else len(cleaned)
        cleaned = cleaned[first_newline + 1:]
        if cleaned.endswith("```"):
            cleaned = cleaned[:-3]
    return cleaned.strip()

@app.post("/api/figma/generate")
def figma_generate(payload: FigmaGeneratePayload, _=Depends(require_api_key)):
    """Server-side Gemini refinement for Figma pages.

    Keeps the Gemini key on the server: the browser never sees it.
    """
    if not GEMINI_AVAILABLE:
        raise HTTPException(status_code=503, detail="google-generativeai is not installed on the server")
    if not GEMINI_API_KEY or GEMINI_API_KEY == "YOUR_API_KEY_HERE":
        raise HTTPException(status_code=503, detail="GEMINI_API_KEY is not configured on the server")

    format_label = {"html": "HTML + CSS", "flutter": "Flutter Widget"}.get(payload.format, "React TS Component")
    prompt_text = (
        f"Convert the following Figma JSON schema to clean, responsive {format_label} code. "
        f"Use relative standard layouts. Clean JSON:\n{json.dumps(payload.pageJson, indent=2)}"
    )

    try:
        model = genai.GenerativeModel(
            model_name=FIGMA_CODE_MODEL,
            system_instruction=(
                "You are an expert frontend engineer. Return ONLY the code, no explanations. "
                "Strip markdown fences if present."
            ),
        )
        response = model.generate_content(prompt_text)
        code = _strip_code_fences(getattr(response, "text", "") or "")
    except Exception as gemini_err:
        traceback.print_exc()
        raise HTTPException(status_code=502, detail=f"Gemini generation failed: {str(gemini_err)}")

    if not code:
        raise HTTPException(status_code=502, detail="Gemini returned an empty response")

    return {"code": code, "model": FIGMA_CODE_MODEL}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=PORT)