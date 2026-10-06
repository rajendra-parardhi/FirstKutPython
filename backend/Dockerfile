###############################################################################
# UI Image Parser - backend API image
#
#   Build:  docker build -t uifigma/api backend/
#   Run:    docker run --rm -p 8000:8000 -v uifigma-data:/data \
#               -e GEMINI_API_KEY=... -e PUBLIC_BASE_URL=http://localhost:8000 \
#               uifigma/api
#   Check:  curl http://localhost:8000/health
#
# Design notes:
#   * torch/torchvision come from the base image, so they are filtered OUT of
#     requirements.txt during install (otherwise pip would upgrade them and
#     wipe the CUDA build).
#   * /data is the persistence root (screenshots, JSON, HTML, Dart, ChromaDB,
#     upload staging). Mount a volume there or the data dies with the container.
#   * Model weights are baked under /models + the user cache so cold starts
#     never re-download them.
#   * --workers must stay 1: models, FAISS and ChromaDB are process globals and
#     Chroma's SQLite store cannot take concurrent writers.
###############################################################################

# PyTorch 2.6.0 + CUDA 12.4 + cuDNN 9, Python 3.11 (~3.2GB compressed).
# Must stay >= 2.5: transformers 5.x (required by sentence-transformers 6.x and
# the Nemotron-3-Embed model) disables torch entirely when it finds torch < 2.5.
FROM pytorch/pytorch:2.6.0-cuda12.4-cudnn9-runtime

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    DATA_DIR=/data \
    HF_HOME=/models/hf \
    SAM_CHECKPOINT=/models/sam_vit_b_01ec64.pth \
    PORT=8000

# System libraries:
#   libgl1/libglib*  -> OpenCV & EasyOCR
#   libgomp1         -> FAISS / OpenMP
#   git              -> CLIP installed from GitHub
#   curl             -> healthcheck + SAM checkpoint download
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        libgl1 \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender1 \
        libgomp1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/backend

# --- Python dependencies (layer cached until requirements.txt changes) -----
# Image-only constraints (kept out of requirements.txt so local dev stays free
# to use newer versions):
#   * torch/torchvision filtered out - the base image provides CUDA builds.
#   * numpy<2 - known-good with torch 2.6.0 / faiss / easyocr.
#   * opencv<4.12 - opencv 4.12+ hard-requires numpy>=2, so it must match.
COPY requirements.txt .
RUN grep -vE '^(torch|torchvision)([[:space:]]|$)' requirements.txt \
        > /tmp/requirements.docker.txt \
    && pip install --no-cache-dir -r /tmp/requirements.docker.txt \
        "numpy<2" "opencv-python-headless<4.12" \
    && python -c "import torch, torchvision, cv2, numpy, faiss, chromadb, easyocr, clip, segment_anything, sentence_transformers; print('deps OK | torch', torch.__version__, '| numpy', numpy.__version__)"

# --- Chromium for the HTML -> image visual-alignment stage -----------------
RUN python -m playwright install --with-deps chromium

# --- Model weights baked into the image ------------------------------------
# SAM checkpoint (fixed public URL, ~375MB)
RUN mkdir -p /models && curl -fSL --retry 3 -o "${SAM_CHECKPOINT}" \
        https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth

# Embeddings + CLIP + OCR weights (all public, no token required)
RUN python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('all-MiniLM-L6-v2'); print('MiniLM cached')" \
    && python -c "import clip; clip.load('ViT-B/32', device='cpu'); print('CLIP cached')" \
    && python -c "import easyocr; easyocr.Reader(['en'], gpu=False); print('EasyOCR cached')"

# Nemotron may be gated behind a HuggingFace token - never fail the build for
# it. If it is skipped, the first boot downloads it into HF_HOME instead.
RUN python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('nvidia/Nemotron-3-Embed-1B-BF16'); print('Nemotron cached')" \
    || echo "WARNING: Nemotron not cached at build time (pass HF_TOKEN as a runtime env var if the model is gated)"

# --- Application -----------------------------------------------------------
COPY app.py .

RUN mkdir -p /data
EXPOSE 8000

# start-period covers model loading and any first-boot weight download.
HEALTHCHECK --interval=30s --timeout=10s --start-period=300s --retries=3 \
    CMD curl -fsS "http://127.0.0.1:${PORT}/health" || exit 1

CMD ["sh", "-c", "uvicorn app:app --host 0.0.0.0 --port ${PORT} --workers 1"]
