import React, { useState, useEffect, useMemo, useRef } from "react";
import axios from "axios";
import JSZip from "jszip";

// Figma Workspace Specific Imports
import { FigmaPreview } from "./components/FigmaPreview";
import { collectPages, createPageLevelJson, generateCodeForPage } from "./utils/figmaToCode";

// API configuration (VITE_API_URL / VITE_API_KEY come from .env at build time)
import { API, apiHeaders, pollJob, saveApiUrl } from "./config";

const EXAMPLE_FILE_KEY = "8VV8hCa7NJjw68b6dykdXN";

function App() {
  // Navigation State: "image", "figma", or "jira"
  const [workspace, setWorkspace] = useState("image");
  const [isConnectorsOpen, setIsConnectorsOpen] = useState(false);
  const connectorsDropdownRef = useRef(null);

  // Dropdown states for Image to Code Output Panel
  const [isAnalysisDropdownOpen, setIsAnalysisDropdownOpen] = useState(false);
  const [isCodeDropdownOpen, setIsCodeDropdownOpen] = useState(false);
  const analysisDropdownRef = useRef(null);
  const codeDropdownRef = useRef(null);

  // Close dropdowns on outside click
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (connectorsDropdownRef.current && !connectorsDropdownRef.current.contains(event.target)) {
        setIsConnectorsOpen(false);
      }
      if (analysisDropdownRef.current && !analysisDropdownRef.current.contains(event.target)) {
        setIsAnalysisDropdownOpen(false);
      }
      if (codeDropdownRef.current && !codeDropdownRef.current.contains(event.target)) {
        setIsCodeDropdownOpen(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  // Backend URL override (runtime; health-checked before saving)
  const [apiEditing, setApiEditing] = useState(false);
  const [apiDraft, setApiDraft] = useState(API);
  const [apiError, setApiError] = useState("");
  const [apiChecking, setApiChecking] = useState(false);

  const handleSaveApiUrl = async () => {
    setApiChecking(true);
    setApiError("");
    const res = await saveApiUrl(apiDraft);
    setApiChecking(false);
    if (res.ok) {
      window.location.reload();
    } else {
      setApiError(res.error);
    }
  };

  // ==========================================
  // WORKSPACE A: SCREENSHOT / IMAGE TO CODE STATES
  // ==========================================
  const [selectedFile, setSelectedFile] = useState(null);
  const [imagePreview, setImagePreview] = useState(null);
  const [isUiLoading, setIsUiLoading] = useState(false);

  // ZIP Ingestion & Selection Modal States
  const [zipFileName, setZipFileName] = useState("");
  const [zipImages, setZipImages] = useState([]); // [{ name, path, file, previewUrl, dimensions, sizeFormatted }]
  const [isZipModalOpen, setIsZipModalOpen] = useState(false);
  const [isUnzipping, setIsUnzipping] = useState(false);
  const [zipSearchQuery, setZipSearchQuery] = useState("");
 
  // Output Main Tabs & Sub-Tabs
  const [activeUiTab, setActiveUiTab] = useState("analysis"); // "analysis" | "generated_code"
  const [activeAnalysisSubTab, setActiveAnalysisSubTab] = useState("sam"); // "sam" | "ocr" | "colors" | "json" | "similarity"
  const [activeCodeSubTab, setActiveCodeSubTab] = useState("html"); // "html" | "flutter"
  const [isSideBySidePreview, setIsSideBySidePreview] = useState(true); // Toggle Code + Live Preview split
 
  const [uiStatus, setUiStatus] = useState("System Ready. Please upload a UI layout image or a .zip archive to begin.");
  const [uiPerformanceMetrics, setUiPerformanceMetrics] = useState(null);
 
  // Model Engine & Elaborate Telemetry State + Popup Modal Control
  const [selectedModelEngine, setSelectedModelEngine] = useState("gemini-3.5-flash");
  const [modelSelectionReason, setModelSelectionReason] = useState(
    "Synthesis Engine: Multi-Modal AST layout parsing and responsive DOM generation with Gemini 3.5 Flash."
  );
  const [isEngineModalOpen, setIsEngineModalOpen] = useState(false);

  // Knowledge Base Modal State (With Local SQLite / SQL support)
  const [isKnowledgeBaseOpen, setIsKnowledgeBaseOpen] = useState(false);
  const [kbTab, setKbTab] = useState("zip"); // "zip" | "doc" | "github" | "sql"
  const [kbLoading, setKbLoading] = useState(false);
  const [kbMessage, setKbMessage] = useState(null);
  const [githubUrl, setGithubUrl] = useState("");

  // IR Match Popup State (Non-blocking popup for PARTIAL_MATCH / NO_MATCH)
  const [irEvaluationResult, setIrEvaluationResult] = useState(null);
  const [isMatchModalOpen, setIsMatchModalOpen] = useState(false);

  // Real-time rendering tracker for pipeline steps (SAM to Code Synthesis)
  const [liveSteps, setLiveSteps] = useState([]);

  // Screenshot Pipeline Outputs
  const [samPreview, setSamPreview] = useState("");
  const [ocrOutput, setOcrOutput] = useState(null);
  const [colorsOutput, setColorsOutput] = useState([]);
  const [similarityOutput, setSimilarityOutput] = useState("");
  const [uiJsonOutput, setUiJsonOutput] = useState("");
  const [uiFlutterOutput, setUiFlutterOutput] = useState("");
  const [uiHtmlOutput, setUiHtmlOutput] = useState("");
 
  // Visual alignment validation metrics
  const [htmlRenderPreview, setHtmlRenderPreview] = useState("");
  const [clipSimilarity, setClipSimilarity] = useState(null);

  // Helper Labels for active tabs
  const analysisSubTabNames = {
    sam: "1. UI Elements",
    ocr: "2. Extracted Text",
    colors: "3. Color Palette",
    json: "4. UI Structure",
    similarity: "5. Accuracy Check"
  };

  // Helper: Format bytes to human readable string
  const formatFileSize = (bytes) => {
    if (!bytes || bytes === 0) return "0 B";
    const k = 1024;
    const sizes = ["B", "KB", "MB", "GB"];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + " " + sizes[i];
  };

  // Helper: Load image dimensions asynchronously
  const getImageDimensions = (url) => {
    return new Promise((resolve) => {
      const img = new Image();
      img.onload = () => resolve(`${img.naturalWidth} × ${img.naturalHeight}px`);
      img.onerror = () => resolve("Unknown dim");
      img.src = url;
    });
  };

  // Helper: Reset pipeline outputs on new image selection
  const resetPipelineOutputs = () => {
    setSamPreview("");
    setOcrOutput(null);
    setColorsOutput([]);
    setSimilarityOutput("");
    setUiJsonOutput("");
    setUiFlutterOutput("");
    setUiHtmlOutput("");
    setHtmlRenderPreview("");
    setClipSimilarity(null);
    setUiPerformanceMetrics(null);
    setLiveSteps([]);
    setIrEvaluationResult(null);
    setIsMatchModalOpen(false);
  };

  // ==========================================
  // WORKSPACE B: FIGMA TO CODE STATES
  // ==========================================
  const [figmaToken, setFigmaToken] = useState("");
  const [fileKey, setFileKey] = useState(EXAMPLE_FILE_KEY);
  const [extractedRawJson, setExtractedRawJson] = useState("");
  const [step1Status, setStep1Status] = useState("idle");
  const [step1Message, setStep1Message] = useState("Ready to extract");

  const [pastedJson, setPastedJson] = useState("");
  const [figmaJson, setFigmaJson] = useState(null);
  const [figmaFileName, setFigmaFileName] = useState("");
  const [figmaFormat, setFigmaFormat] = useState("html");
  const [activeFigmaPageId, setActiveFigmaPageId] = useState("");
  const [figmaJsonError, setFigmaJsonError] = useState(null);
  const [imageAssetMessage, setImageAssetMessage] = useState("");

  const [activeFigmaTab, setActiveFigmaTab] = useState("compiler");
  const [figmaCompilerCode, setFigmaCompilerCode] = useState("");
  const [figmaAiCodeCache, setFigmaAiCodeCache] = useState({});
  const [isFigmaAiLoading, setIsFigmaAiLoading] = useState(false);
  const [figmaAiError, setFigmaAiError] = useState(null);

  // Compute Figma values
  const figmaPages = useMemo(() => {
    return figmaJson ? collectPages(figmaJson.document) : [];
  }, [figmaJson]);

  const activeFigmaPage = useMemo(() => {
    if (!figmaPages.length) return null;
    return figmaPages.find((page) => page.id === activeFigmaPageId) || figmaPages[0];
  }, [figmaPages, activeFigmaPageId]);

  // KB File Upload with automatic IR re-evaluation trigger
  const handleKbFileUpload = async (event, endpoint) => {
    const file = event.target.files?.[0];
    if (!file) return;

    setKbLoading(true);
    setKbMessage({ type: "info", text: `Uploading and analyzing ${file.name}...` });
    const formData = new FormData();
    formData.append("file", file);

    try {
      const response = await axios.post(`${API}/api/kb/${endpoint}`, formData, {
        headers: apiHeaders(),
        timeout: 120000,
      });
      const job = await pollJob(response.data.job_id, (snapshot) => {
        const progress = snapshot.progress;
        if (progress?.total) {
          setKbMessage({
            type: "info",
            text: `${progress.current_file || "Indexing Knowledge"}: ${progress.processed || 0} of ${progress.total}`,
          });
        }
      });
      const result = job.result || {};
      const details = result.details || {};
     
      let message = "";
      if (endpoint === "ingest_zip") {
        message = `Indexed ${details.processed || 0} images${details.errors?.length ? `; ${details.errors.length} failed` : ""}.`;
      } else if (endpoint === "ingest_sql") {
        message = `Indexed ${result.chunks_stored || 0} SQL schema/table chunks into local vector store.`;
      } else {
        message = `Indexed ${result.chunks_stored || 0} document chunks.`;
      }

      setKbMessage({ type: "success", text: `${message} Auto-rerunning IR retrieval on your request...` });

      if (selectedFile) {
        setTimeout(handleIngestionCompleteAutoRerun, 800);
      }
    } catch (error) {
      setKbMessage({
        type: "error",
        text: error.response?.data?.detail || error.message || "Knowledge-base ingestion failed.",
      });
    } finally {
      setKbLoading(false);
      event.target.value = "";
    }
  };

  const handleGithubIngest = async (event) => {
    event.preventDefault();
    if (!githubUrl.trim()) return;

    setKbLoading(true);
    setKbMessage({ type: "info", text: "Starting repository indexing..." });
    try {
      const response = await axios.post(`${API}/api/kb/ingest_github`, {
        repo_url: githubUrl.trim(),
        branch: "main",
      }, { headers: apiHeaders(), timeout: 120000 });
      const job = await pollJob(response.data.job_id, (snapshot) => {
        const progress = snapshot.progress;
        if (progress?.total) {
          setKbMessage({
            type: "info",
            text: `${progress.current_file || "Indexing repository"}: ${progress.processed || 0} of ${progress.total}`,
          });
        }
      });
      setKbMessage({ type: "success", text: `Indexed ${job.result?.files_indexed || 0} repository files. Auto-rerunning IR retrieval...` });
      setGithubUrl("");

      if (selectedFile) {
        setTimeout(handleIngestionCompleteAutoRerun, 800);
      }
    } catch (error) {
      setKbMessage({
        type: "error",
        text: error.response?.data?.detail || error.message || "Repository indexing failed.",
      });
    } finally {
      setKbLoading(false);
    }
  };

  const detectedPagesDebugJson = useMemo(() => {
    return JSON.stringify(figmaPages.map(createPageLevelJson), null, 2);
  }, [figmaPages]);

  // ==========================================
  // WORKSPACE A: SCREENSHOT & ZIP PIPELINE LOGIC
  // ==========================================
  const handleUiFileChange = async (e) => {
    const file = e.target.files[0];
    if (!file) return;

    const lowerName = file.name.toLowerCase();
    const isZip = lowerName.endsWith(".zip") || file.type === "application/zip" || file.type === "application/x-zip-compressed";

    // ----------------------------------------------------
    // CASE A: User selected a .ZIP archive
    // ----------------------------------------------------
    if (isZip) {
      setZipFileName(file.name);
      setIsUnzipping(true);
      setZipImages([]);
      setZipSearchQuery("");
      setUiStatus(`Unpacking ZIP archive "${file.name}" in background...`);

      try {
        const zip = new JSZip();
        const contents = await zip.loadAsync(file);
        const extracted = [];
        const supportedExtensions = [".png", ".jpg", ".jpeg", ".webp", ".svg", ".bmp"];

        for (const [relativePath, zipEntry] of Object.entries(contents.files)) {
          // 1. Skip directories
          if (zipEntry.dir) continue;

          // 2. Filter out OS hidden files and metadata (__MACOSX, .DS_Store, .* files)
          const fileName = relativePath.split("/").pop() || "";
          if (
            relativePath.includes("__MACOSX") ||
            fileName.startsWith(".") ||
            fileName.toLowerCase() === "thumbs.db"
          ) {
            continue;
          }

          // 3. Match image extensions
          const entryLower = fileName.toLowerCase();
          const hasImageExt = supportedExtensions.some((ext) => entryLower.endsWith(ext));

          if (hasImageExt) {
            const blob = await zipEntry.async("blob");
           
            // Detect MIME type
            let mimeType = "image/png";
            if (entryLower.endsWith(".jpg") || entryLower.endsWith(".jpeg")) mimeType = "image/jpeg";
            else if (entryLower.endsWith(".webp")) mimeType = "image/webp";
            else if (entryLower.endsWith(".svg")) mimeType = "image/svg+xml";
            else if (entryLower.endsWith(".bmp")) mimeType = "image/bmp";

            const previewUrl = URL.createObjectURL(blob);
            const dimensions = await getImageDimensions(previewUrl);
            const imgFile = new File([blob], fileName, { type: mimeType });

            extracted.push({
              name: fileName,
              path: relativePath,
              file: imgFile,
              previewUrl,
              dimensions,
              sizeBytes: blob.size,
              sizeFormatted: formatFileSize(blob.size),
            });
          }
        }

        if (extracted.length === 0) {
          setUiStatus("Warning: No valid image files (.png, .jpg, .webp, .svg) found in the selected ZIP archive.");
          alert("No valid images (.png, .jpg, .webp, .svg) were detected inside this zip archive.");
        } else {
          setZipImages(extracted);
          setIsZipModalOpen(true);
          setUiStatus(`Loaded ${extracted.length} screens from "${file.name}". Please pick an image.`);
        }
      } catch (err) {
        console.error("Failed to unpack zip:", err);
        setUiStatus("Error: Unable to unpack ZIP folder. Please ensure file is valid.");
        alert("Failed to unpack ZIP archive. Please verify the archive is not corrupted.");
      } finally {
        setIsUnzipping(false);
        e.target.value = ""; // Reset input so same file can be picked again if desired
      }
      return;
    }

    // ----------------------------------------------------
    // CASE B: User selected a single image (.png, .jpg, etc.)
    // ----------------------------------------------------
    if (file.type.startsWith("image/")) {
      setSelectedFile(file);
      setImagePreview(URL.createObjectURL(file));
      resetPipelineOutputs();
      setUiStatus(`Loaded "${file.name}". Click 'Run Code Engine Pipeline' to evaluate.`);
      e.target.value = "";
    }
  };

  // Called when user clicks an image card in the Zip Selection Modal
  const handleSelectImageFromZip = (imageItem) => {
    setSelectedFile(imageItem.file);
    setImagePreview(imageItem.previewUrl);
    resetPipelineOutputs();
    setIsZipModalOpen(false);
    setUiStatus(`Selected "${imageItem.name}" from zip (${imageItem.dimensions}, ${imageItem.sizeFormatted}). Ready to run.`);
  };

  const handleProcessUiPipeline = async (forceAi = false) => {
    if (!selectedFile) return;
    setIsUiLoading(true);
    setUiPerformanceMetrics(null);
    setUiStatus(forceAi ? "Synthesizing code layout with AI Orchestration..." : "Evaluating IR Retrieval against Knowledge Repo...");

    const initialSteps = [
      { id: 1, name: "Element Detection", status: "processing", duration: null },
      { id: 2, name: "Text Extraction", status: "waiting", duration: null },
      { id: 3, name: "Color Palette Extraction", status: "waiting", duration: null },
      { id: 4, name: "Accuracy & Knowledge Verification", status: "waiting", duration: null },
      { id: 5, name: "Intelligent Synthesis Orchestration", status: "waiting", duration: null },
      { id: 6, name: "Visual Alignment Check", status: "waiting", duration: null },
      { id: 7, name: "Codebase Promotion Governance", status: "waiting", duration: null },
    ];
    setLiveSteps(initialSteps);

    const applyLiveProgress = (backendSteps, stageLabel) => {
      const steps = backendSteps || [];
      setLiveSteps(initialSteps.map((step, idx) => {
        const done = steps.find((s) => s.stage === idx + 1);
        if (done) return { ...step, status: "completed", duration: `${done.duration}s` };
        if (steps.length === idx) return { ...step, status: "processing" };
        return step;
      }));
      if (stageLabel) setUiStatus(stageLabel);
    };

    const formData = new FormData();
    formData.append("file", selectedFile);
    if (forceAi) formData.append("force_ai", "true");

    try {
      const res = await axios.post(`${API}/api/process_ui`, formData, {
        headers: apiHeaders({ "Content-Type": "multipart/form-data" }),
        timeout: 300000,
      });

      const job = await pollJob(res.data.job_id, (snapshot) => {
        applyLiveProgress(snapshot.steps, snapshot.stage);
      });

      const result = job.result || {};
     
      // Populate Tab Outputs
      if (result.sam_preview) setSamPreview(`data:image/png;base64,${result.sam_preview}`);
      if (result.json || result.ui_json) setUiJsonOutput(result.json || result.ui_json);

      const extractedOcr = result.ocr_text || result.ocrText || null;
      setOcrOutput(extractedOcr);
      setColorsOutput(result.colors || []);
      setUiFlutterOutput(result.flutter || result.flutter_code || result.flutterOutput || "");
      setUiHtmlOutput(result.html || result.html_code || result.html_css || result.htmlCssOutput || "");
      setSimilarityOutput(result.similarity || result.similarity_logs || result.similarityLogs || "Analysis complete.");

      if (result.html_render_preview) {
        setHtmlRenderPreview(`data:image/png;base64,${result.html_render_preview}`);
      }
      setClipSimilarity(result.clip_similarity !== undefined ? result.clip_similarity : null);

      if (result.model_engine) {
        setSelectedModelEngine(result.model_engine);
        setModelSelectionReason(result.model_reason || "Automated multi-modal routing determined by synthesis orchestrator.");
      }

      const matchStatus = result.ir_match_status || "NO_MATCH";
      setIrEvaluationResult({
        status: matchStatus,
        relevance: result.relevance_score || 0,
        coverage: result.coverage_score || 0,
        unresolved: result.unresolved_requirements || [],
      });

      if (!forceAi && (matchStatus === "PARTIAL_MATCH" || matchStatus === "NO_MATCH")) {
        setIsMatchModalOpen(true);
        setUiStatus(`Accuracy Engine Flagged: ${matchStatus}. Review outputs or enrich repository.`);
      } else {
        setUiStatus(result.status || "Pipeline Execution Completed");
      }

      if (result.performance_metrics) {
        const backendSteps = result.performance_metrics.steps || [];
        const mappedSteps = initialSteps.map((step, idx) => {
          const correspondingStage = backendSteps.find(s => s.stage === idx + 1);
          return {
            ...step,
            status: "completed",
            duration: correspondingStage ? `${correspondingStage.duration}s` : "0.5s"
          };
        });
        setLiveSteps(mappedSteps);
        setUiPerformanceMetrics(result.performance_metrics);
      }

    } catch (err) {
      console.error(err);
      setUiStatus(`Error: ${err.response?.data?.detail || err.message || "Pipeline execution failed."}`);

      setLiveSteps((prevSteps) =>
        prevSteps.map((step) =>
          step.status === "processing" || step.status === "waiting"
            ? { ...step, status: "failed", duration: "Failed" }
            : step
        )
      );
    } finally {
      setIsUiLoading(false);
    }
  };

  const handleDecisionEnrichRepo = () => {
    setIsMatchModalOpen(false);
    setIsKnowledgeBaseOpen(true);
  };

  const handleDecisionContinueAi = () => {
    setIsMatchModalOpen(false);
    handleProcessUiPipeline(true);
  };

  const handleIngestionCompleteAutoRerun = () => {
    setIsKnowledgeBaseOpen(false);
    setUiStatus("Knowledge Repo enriched. Automatically rerunning retrieval on original request...");
    handleProcessUiPipeline(false);
  };

  const openInDartPad = () => {
    if (!uiFlutterOutput) return;
    const dartpadWindow = window.open("https://dartpad.dev/embed-flutter.html", "_blank");
    if (dartpadWindow) {
      setTimeout(() => {
        dartpadWindow.postMessage({ source: uiFlutterOutput, type: "sourceCode" }, "*");
      }, 2500);
    }
  };

  // Filtered zip images list based on search query
  const filteredZipImages = useMemo(() => {
    if (!zipSearchQuery.trim()) return zipImages;
    const q = zipSearchQuery.toLowerCase();
    return zipImages.filter((img) => img.name.toLowerCase().includes(q));
  }, [zipImages, zipSearchQuery]);

  // ==========================================
  // WORKSPACE B: FIGMA PIPELINE LOGIC
  // ==========================================
  useEffect(() => {
    setFigmaCodeCache({});
  }, [figmaFormat, figmaFileName]);

  const setFigmaCodeCache = (val) => {
    setFigmaAiCodeCache(val);
  };

  useEffect(() => {
    if (!activeFigmaPage) {
      setFigmaCompilerCode("");
      return;
    }
    try {
      const code = generateCodeForPage(activeFigmaPage, {
        format: figmaFormat,
        componentName: figmaFileName || activeFigmaPage.name || "FigmaExport"
      });
      setFigmaCompilerCode(code);
      setFigmaJsonError(null);
    } catch (error) {
      setFigmaJsonError(error.message || "Error compiling standard code");
      setFigmaCompilerCode("");
    }
  }, [activeFigmaPage, figmaFormat, figmaFileName]);

  useEffect(() => {
    if (activeFigmaTab === "ai" && activeFigmaPage && !figmaAiCodeCache[activeFigmaPage.id] && !isFigmaAiLoading) {
      generateCodeWithGemini(activeFigmaPage);
    }
  }, [activeFigmaTab, activeFigmaPage]);

  const normalizeFigmaFileKey = (value) => {
    const trimmed = value.trim();
    if (!trimmed) return "";
    const fileMatch = trimmed.match(/figma\.com\/(?:file|design)\/([a-zA-Z0-9]+)/);
    if (fileMatch?.[1]) return fileMatch[1];
    return trimmed.replace(/^\/+|\/+$/g, "");
  };

  const handleExtractSubmit = async (e) => {
    e.preventDefault();
    setStep1Status("loading");
    setStep1Message("Fetching from Figma API...");
    setExtractedRawJson("");

    try {
      const cleanKey = normalizeFigmaFileKey(fileKey);
      const cleanToken = figmaToken.trim();

      if (!cleanKey || !cleanToken) {
        throw new Error("Enter a valid Figma file key and personal token");
      }

      const res = await axios.get(`${API}/figma-api/v1/files/${encodeURIComponent(cleanKey)}`, {
        headers: apiHeaders({ "X-Figma-Token": cleanToken }),
        timeout: 60000,
      });

      const stringified = JSON.stringify(res.data, null, 2);
      setExtractedRawJson(stringified);
      setStep1Status("ready");
      setStep1Message("Figma JSON loaded & auto-parsed!");

      handlePastedJsonChange(stringified);
    } catch (error) {
      setStep1Status("error");
      setStep1Message(error.response?.data?.detail || error.message || "Unable to extract Figma JSON");
    }
  };

  const handlePastedJsonChange = async (value) => {
    setPastedJson(value);
    if (!value.trim()) {
      setFigmaJson(null);
      setFigmaCompilerCode("");
      setActiveFigmaPageId("");
      setFigmaAiCodeCache({});
      setFigmaJsonError(null);
      setImageAssetMessage("");
      return;
    }

    try {
      const parsed = JSON.parse(value);
      setFigmaJson(parsed);
      setFigmaJsonError(null);
      if (parsed.name && !figmaFileName) {
        setFigmaFileName(parsed.name);
      }

      const foundPages = collectPages(parsed.document);
      if (foundPages.length > 0) {
        setActiveFigmaPageId(foundPages[0].id);
      }

      const processed = await extractImageAssetsForFigmaJson(parsed);
      setFigmaJson(processed);
    } catch (err) {
      setFigmaJson(null);
      setFigmaCompilerCode("");
      setActiveFigmaPageId("");
      setFigmaAiCodeCache({});
      setImageAssetMessage("");
      setFigmaJsonError("Invalid JSON structure format.");
    }
  };

  const extractImageAssetsForFigmaJson = async (parsed) => {
    const cleanKey = normalizeFigmaFileKey(fileKey);
    const cleanToken = figmaToken.trim();

    if (!cleanKey || !cleanToken) {
      setImageAssetMessage("Image extraction skipped: No Figma parameters provided.");
      return parsed;
    }

    setImageAssetMessage("Extracting assets from Figma API...");

    try {
      const res = await axios.post(`${API}/figma-assets/extract`, {
        fileKey: cleanKey,
        token: cleanToken,
        figmaJson: parsed
      }, {
        headers: apiHeaders(),
        timeout: 60000,
      });

      const count = res.data.assets?.length ?? 0;
      const imageRefCount = res.data.imageRefCount ?? 0;

      if (count > 0) {
        setImageAssetMessage(`✓ Downloaded ${count}/${imageRefCount} images to the backend asset store.`);
      } else {
        setImageAssetMessage("✓ No graphic asset references found in this schema.");
      }

      return res.data.figmaJson;
    } catch (error) {
      setImageAssetMessage(`Asset mapping skipped: ${error.message}`);
      return parsed;
    }
  };

  const generateCodeWithGemini = async (pageNode) => {
    if (!pageNode) return;
    setIsFigmaAiLoading(true);
    setFigmaAiError(null);

    const pageLevelJson = createPageLevelJson(pageNode);

    try {
      const res = await axios.post(`${API}/api/figma/generate`, {
        format: figmaFormat,
        componentName: figmaFileName || pageNode.name || "FigmaExport",
        pageJson: pageLevelJson,
      }, {
        headers: apiHeaders(),
        timeout: 120000,
      });

      const code = res.data?.code || "";
      if (!code) throw new Error("The server returned an empty code sample");

      setFigmaAiCodeCache((prev) => ({ ...prev, [pageNode.id]: code }));
    } catch (err) {
      setFigmaAiError(err.response?.data?.detail || err.message || "Error contacting the code synthesis endpoint");
    } finally {
      setIsFigmaAiLoading(false);
    }
  };

  const copyToClipboard = (text) => {
    if (!text) return;
    navigator.clipboard.writeText(text);
    alert("Copied successfully.");
  };

  const getActiveConnectorLabel = () => {
    switch (workspace) {
      case "image":
      case "screenshot":
        return " Image";
      case "figma":
        return " Figma";
      case "jira":
        return " Jira";
      default:
        return "Connectors";
    }
  };

  return (
    <div className="app-container">
      {/* Universal Dashboard Header */}
      <header className="main-header">
        <div className="logo-section">
          <span className="logo-rocket"></span>
          <h1>UI Image Parser</h1>
        </div>
       
        {/* Navigation Selector: Connectors Dropdown */}
        <div
          className="connectors-dropdown-wrapper"
          ref={connectorsDropdownRef}
          style={{ position: "relative" }}
        >
          <button
            type="button"
            className="connectors-dropdown-trigger"
            onClick={() => setIsConnectorsOpen((prev) => !prev)}
            style={{
              display: "flex",
              alignItems: "center",
              gap: "10px",
              padding: "8px 16px",
              background: "linear-gradient(135deg, #1e293b, #0f172a)",
              border: "1px solid #38bdf8",
              borderRadius: "6px",
              color: "#f8fafc",
              fontSize: "13px",
              fontWeight: "600",
              cursor: "pointer",
              boxShadow: "0 4px 12px rgba(0, 0, 0, 0.35)",
              transition: "all 0.2s ease"
            }}
          >
            <span style={{ color: "#38bdf8" }}></span>
            <span>Connectors: <strong>{getActiveConnectorLabel()}</strong></span>
            <span style={{ fontSize: "10px", color: "#38bdf8", marginLeft: "4px" }}>
              {isConnectorsOpen ? "▲" : "▼"}
            </span>
          </button>

          {isConnectorsOpen && (
            <div
              className="connectors-dropdown-menu"
              style={{
                position: "absolute",
                top: "calc(100% + 6px)",
                left: 0,
                background: "#0f172a",
                border: "1px solid #334155",
                borderRadius: "8px",
                padding: "6px",
                minWidth: "190px",
                boxShadow: "0 12px 30px rgba(0, 0, 0, 0.65)",
                zIndex: 1000,
                display: "flex",
                flexDirection: "column",
                gap: "4px"
              }}
            >
              {/* Option 1: Image */}
              <button
                type="button"
                onClick={() => {
                  setWorkspace("image");
                  setIsConnectorsOpen(false);
                }}
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: "8px",
                  padding: "9px 12px",
                  borderRadius: "5px",
                  border: "none",
                  background: workspace === "image" || workspace === "screenshot" ? "#1e293b" : "transparent",
                  color: workspace === "image" || workspace === "screenshot" ? "#38bdf8" : "#cbd5e1",
                  fontSize: "13px",
                  fontWeight: workspace === "image" || workspace === "screenshot" ? "700" : "500",
                  textAlign: "left",
                  cursor: "pointer"
                }}
              >
                <span></span> Image
              </button>

              {/* Option 2: Figma */}
              <button
                type="button"
                onClick={() => {
                  setWorkspace("figma");
                  setIsConnectorsOpen(false);
                }}
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: "8px",
                  padding: "9px 12px",
                  borderRadius: "5px",
                  border: "none",
                  background: workspace === "figma" ? "#1e293b" : "transparent",
                  color: workspace === "figma" ? "#38bdf8" : "#cbd5e1",
                  fontSize: "13px",
                  fontWeight: workspace === "figma" ? "700" : "500",
                  textAlign: "left",
                  cursor: "pointer"
                }}
              >
                <span></span> Figma
              </button>

              {/* Option 3: Jira */}
              <button
                type="button"
                onClick={() => {
                  setIsConnectorsOpen(false);
                  window.open("/typ.html", "_blank"); 
                }}
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: "8px",
                  padding: "9px 12px",
                  borderRadius: "5px",
                  border: "none",
                  background: workspace === "jira" ? "#1e293b" : "transparent",
                  color: workspace === "jira" ? "#38bdf8" : "#cbd5e1",
                  fontSize: "13px",
                  fontWeight: workspace === "jira" ? "700" : "500",
                  textAlign: "left",
                  cursor: "pointer"
                }}
              >
                <span></span> Jira
              </button>
            </div>
          )}
        </div>

        <div className="connection-status">
          <div className="status-indicator"></div>
          {apiEditing ? (
            <span style={{ display: "flex", alignItems: "center", gap: "6px" }}>
              <input
                value={apiDraft}
                onChange={(e) => setApiDraft(e.target.value)}
                placeholder="https://<pod>-8000.proxy.runpod.net"
                style={{ width: "260px", padding: "4px 6px", fontSize: "12px" }}
                onKeyDown={(e) => { if (e.key === "Enter") handleSaveApiUrl(); }}
              />
              <button className="toggle-btn" onClick={handleSaveApiUrl} disabled={apiChecking}>
                {apiChecking ? "..." : "Save"}
              </button>
              <button
                className="toggle-btn"
                onClick={() => { setApiEditing(false); setApiError(""); }}
              >
                Cancel
              </button>
              {apiError && (
                <span style={{ color: "#f87171", fontSize: "12px", maxWidth: "260px" }}>
                  {apiError}
                </span>
              )}
            </span>
          ) : (
            <span
              title="Click to change the backend URL"
              onClick={() => { setApiDraft(API); setApiEditing(true); setApiError(""); }}
              style={{ cursor: "pointer", textDecoration: "underline dotted" }}
            >
              API: {API}
            </span>
          )}
        </div>
      </header>

      {/* =======================================================
          WORKSPACE 1: IMAGE (SCREENSHOT) TO CODE PIPELINE
          ======================================================= */}
      {(workspace === "image" || workspace === "screenshot") && (
        <main className="workspace-grid" style={{ gridTemplateColumns: "420px 1fr" }}>
         
          {/* LEFT CONTROL PANEL */}
          <section className="panel control-panel" style={{ display: "flex", flexDirection: "column", height: "100%", overflow: "hidden" }}>
            <div className="panel-header" style={{ flexShrink: 0 }}>
              <h2>Source UI Control Panel</h2>
            </div>
           
            {/* Scrollable Container Body Wrapper */}
            <div className="panel-body" style={{ flex: 1, minHeight: 0, overflowY: "auto", padding: "16px", display: "flex", flexDirection: "column", gap: "14px" }}>
             
              {/* KNOWLEDGE REPO BUTTON */}
              <button
                onClick={() => setIsKnowledgeBaseOpen(true)}
                style={{
                  width: "100%",
                  padding: "10px 14px",
                  background: "linear-gradient(135deg, #1e293b, #0f172a)",
                  border: "1px solid #38bdf8",
                  borderRadius: "6px",
                  color: "#38bdf8",
                  fontSize: "12px",
                  fontWeight: "bold",
                  cursor: "pointer",
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "space-between",
                  boxShadow: "0 4px 12px rgba(0, 0, 0, 0.3)",
                  flexShrink: 0
                }}
              >
                <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                  <span></span>
                  <span>Knowledge Base</span>
                </div>
                <span style={{
                  background: uiJsonOutput ? "#10b98125" : "#64748b25",
                  color: uiJsonOutput ? "#34d399" : "#94a3b8",
                  border: `1px solid ${uiJsonOutput ? "#10b981" : "#475569"}`,
                  padding: "2px 6px",
                  borderRadius: "4px",
                  fontSize: "10px"
                }}>
                  {uiJsonOutput ? "Ready" : "Update"}
                </span>
              </button>

              {/* Terminal Log Container */}
              <div
                className="terminal-log"
                style={{
                  display: "flex",
                  flexDirection: "column",
                  height: "350px",
                  border: "1px solid #334155",
                  borderRadius: "8px",
                  backgroundColor: "#0b1329",
                  boxShadow: "0 8px 24px rgba(0, 0, 0, 0.45)",
                  overflow: "hidden",
                  flexShrink: 0
                }}
              >
                <div
                  className="terminal-header"
                  style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                    padding: "10px 14px",
                    backgroundColor: "#1e293b",
                    borderBottom: "1px solid #334155",
                    flexShrink: 0
                  }}
                >
                  <div style={{ display: "flex", alignItems: "center" }}>
                    <span className="term-dot red" style={{ width: "8px", height: "8px", borderRadius: "50%", backgroundColor: "#ef4444", marginRight: "6px" }}></span>
                    <span className="term-dot yellow" style={{ width: "8px", height: "8px", borderRadius: "50%", backgroundColor: "#f59e0b", marginRight: "6px" }}></span>
                    <span className="term-dot green" style={{ width: "8px", height: "8px", borderRadius: "50%", backgroundColor: "#10b981", marginRight: "10px" }}></span>
                    <span className="term-title" style={{ color: "#cbd5e1", fontSize: "11px", fontWeight: "bold", fontFamily: "monospace", textTransform: "uppercase", letterSpacing: "0.8px" }}>
                      SYSTEM LOGS & PIPELINE TELEMETRY
                    </span>
                  </div>

                  <span style={{
                    fontSize: "9px",
                    background: "#0284c7",
                    color: "#ffffff",
                    padding: "2px 7px",
                    borderRadius: "4px",
                    fontWeight: "600",
                    fontFamily: "monospace"
                  }}>
                    LIVE STREAM
                  </span>
                </div>

                <div
                  className="terminal-body"
                  style={{
                    flex: 1,
                    overflowY: "auto",
                    padding: "12px 14px",
                    fontFamily: "monospace",
                    lineHeight: "1.45"
                  }}
                >
                  <div style={{ display: "flex", alignItems: "flex-start", gap: "8px", margin: "0 0 10px 0" }}>
                    <span style={{ color: "#38bdf8", fontSize: "12px" }}>❯</span>
                    <p className="log-text" style={{ color: "#38bdf8", fontWeight: "600", margin: 0, fontSize: "11.5px" }}>
                      {uiStatus}
                    </p>
                  </div>
                 
                  {liveSteps.length > 0 && (
                    <div className="metrics-profiler" style={{ borderTop: "1px solid #1e293b", paddingTop: "8px" }}>
                      <div style={{ color: "#94a3b8", fontSize: "10px", marginBottom: "8px", letterSpacing: "0.6px", fontWeight: "bold" }}>
                        PIPELINE EXECUTION STAGES:
                      </div>
                     
                      {liveSteps.map((step) => {
                        let stepColor = "#64748b";
                        let statusMarker = "waiting";
                       
                        if (step.status === "completed") {
                          stepColor = "#34d399";
                          statusMarker = `✓ ${step.duration}`;
                        } else if (step.status === "processing") {
                          stepColor = "#fbbf24";
                          statusMarker = "processing...";
                        } else if (step.status === "failed") {
                          stepColor = "#f87171";
                          statusMarker = "✗ failed";
                        }

                        return (
                          <div
                            key={step.id}
                            style={{
                              display: "flex",
                              justifyContent: "space-between",
                              fontSize: "11px",
                              margin: "5px 0",
                              color: stepColor
                            }}
                          >
                            <span>Stage {step.id}: {step.name}</span>
                            <span style={{ fontWeight: "600" }}>{statusMarker}</span>
                          </div>
                        );
                      })}

                      {/* SYSTEM ENGINE BAR */}
                      <div
                        style={{
                          marginTop: "12px",
                          padding: "10px",
                          backgroundColor: "#111c38",
                          borderRadius: "6px",
                          border: "1px solid #1e293b",
                          display: "flex",
                          flexDirection: "column",
                          gap: "6px"
                        }}
                      >
                        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                          <span style={{ color: "#94a3b8", fontSize: "10.5px", fontWeight: "bold" }}>SYNTHESIS ENGINE:</span>
                         
                          <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                            <span style={{
                              color: "#38bdf8",
                              backgroundColor: "#0369a120",
                              border: "1px solid #0284c7",
                              padding: "2px 8px",
                              borderRadius: "4px",
                              fontWeight: "bold",
                              fontSize: "11px",
                              fontFamily: "monospace"
                            }}>
                              {selectedModelEngine}
                            </span>
                           
                            <button
                              onClick={() => setIsEngineModalOpen(true)}
                              style={{
                                background: "#0284c7",
                                color: "#ffffff",
                                border: "none",
                                borderRadius: "4px",
                                padding: "2px 6px",
                                fontSize: "10px",
                                fontWeight: "bold",
                                cursor: "pointer"
                              }}
                              title="Click to view full Engine details"
                            >
                               View Engine Details
                            </button>
                          </div>
                        </div>

                        <div style={{ borderTop: "1px dashed #1e293b", paddingTop: "6px", marginTop: "2px" }}>
                          <span style={{ color: "#f59e0b", fontSize: "10px", fontWeight: "bold", display: "block", marginBottom: "3px" }}>
                            ELABORATED ARCHITECTURAL CONTEXT:
                          </span>
                          <p style={{ color: "#cbd5e1", fontSize: "10.5px", lineHeight: "1.4", margin: 0 }}>
                            {modelSelectionReason}
                          </p>
                        </div>
                      </div>

                      {uiPerformanceMetrics && !isUiLoading && (
                        <div
                          style={{
                            display: "flex",
                            justifyContent: "space-between",
                            fontSize: "11px",
                            margin: "10px 0 0 0",
                            borderTop: "1px dashed #334155",
                            paddingTop: "8px",
                            fontWeight: "bold",
                            color: "#60a5fa"
                          }}
                        >
                          <span>TOTAL ENGINE RUNTIME</span>
                          <span>{uiPerformanceMetrics.total_duration_sec}s</span>
                        </div>
                      )}
                    </div>
                  )}
                </div>
              </div>

              {/* DUAL FILE UPLOAD: SINGLE IMAGE OR .ZIP ARCHIVE */}
              <div className="upload-wrapper" style={{ flexShrink: 0, display: "flex", flexDirection: "column", gap: "6px" }}>
                <label className="file-upload-label" style={{ opacity: isUnzipping ? 0.7 : 1 }}>
                  <input
                    type="file"
                    accept="image/*,.zip,application/zip,application/x-zip-compressed"
                    disabled={isUnzipping || isUiLoading}
                    onChange={handleUiFileChange}
                  />
                  <div className="upload-box-content">
                    <span className="upload-icon">{isUnzipping ? "⏳" : "📁"}</span>
                    <span>
                      {isUnzipping ? "Unpacking ZIP Archive..." : "Input"}
                    </span>
                  </div>
                </label>

                {/* If a zip file was previously loaded, show quick re-open button */}
                {zipImages.length > 0 && (
                  <button
                    type="button"
                    onClick={() => setIsZipModalOpen(true)}
                    style={{
                      background: "#1e293b",
                      border: "1px dashed #38bdf8",
                      borderRadius: "6px",
                      color: "#38bdf8",
                      fontSize: "11.5px",
                      fontWeight: "600",
                      padding: "7px 10px",
                      cursor: "pointer",
                      display: "flex",
                      alignItems: "center",
                      justifyContent: "center",
                      gap: "6px"
                    }}
                  >
                    <span></span>
                    <span>Browse Loaded ZIP Screens ({zipImages.length})</span>
                  </button>
                )}
              </div>

              {imagePreview && (
                <div className="source-preview-container" style={{ flexShrink: 0 }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "6px" }}>
                    <h4 style={{ margin: 0 }}>Uploaded Input Image:</h4>
                    {selectedFile && (
                      <span style={{ fontSize: "10.5px", color: "#38bdf8", fontWeight: "600" }}>
                        {formatFileSize(selectedFile.size)}
                      </span>
                    )}
                  </div>
                  <img src={imagePreview} alt="Uploaded interface" className="source-img" style={{ maxHeight: "220px", objectFit: "contain" }} />
                  {selectedFile && (
                    <span style={{ fontSize: "11px", color: "#94a3b8", display: "block", marginTop: "4px", textAlign: "center", wordBreak: "break-all" }}>
                      📄 {selectedFile.name}
                    </span>
                  )}
                </div>
              )}

              <button
                onClick={() => handleProcessUiPipeline(false)}
                disabled={isUiLoading || !selectedFile || isUnzipping}
                className={`process-button ${isUiLoading ? "btn-loading" : ""}`}
                style={{ flexShrink: 0, marginTop: "8px" }}
              >
                {isUiLoading ? "Running Pipeline Engine..." : "Run Code Engine Pipeline"}
              </button>

            </div>
          </section>

          {/* Right Tabbed Output Panel */}
          <section className="panel output-panel" style={{ display: "flex", flexDirection: "column", height: "100%", overflow: "hidden" }}>
           
            {/* DROPDOWN-BASED TABS HEADER */}
            <div
              className="tabs-header"
              style={{
                flexShrink: 0,
                display: "flex",
                alignItems: "center",
                justifyContent: "space-between",
                padding: "10px 16px",
                background: "#091122",
                borderBottom: "1px solid #334155",
                gap: "12px",
                flexWrap: "wrap"
              }}
            >
              <div style={{ display: "flex", alignItems: "center", gap: "12px", flexWrap: "wrap" }}>
               
                {/* 1. IMAGE ANALYSIS DROPDOWN */}
                <div style={{ position: "relative" }} ref={analysisDropdownRef}>
                  <button
                    type="button"
                    onClick={() => {
                      setActiveUiTab("analysis");
                      setIsAnalysisDropdownOpen((prev) => !prev);
                      setIsCodeDropdownOpen(false);
                    }}
                    style={{
                      display: "flex",
                      alignItems: "center",
                      gap: "8px",
                      padding: "8px 14px",
                      borderRadius: "6px",
                      cursor: "pointer",
                      fontSize: "12.5px",
                      fontWeight: activeUiTab === "analysis" ? "700" : "500",
                      background: activeUiTab === "analysis" ? "#1e293b" : "#0f172a",
                      color: activeUiTab === "analysis" ? "#38bdf8" : "#94a3b8",
                      border: activeUiTab === "analysis" ? "1px solid #38bdf8" : "1px solid #334155",
                      boxShadow: activeUiTab === "analysis" ? "0 2px 10px rgba(56, 189, 248, 0.2)" : "none",
                      transition: "all 0.2s ease"
                    }}
                  >
                    <span></span>
                    <span>Image Analysis: <strong style={{ color: "#f8fafc" }}>{analysisSubTabNames[activeAnalysisSubTab] || "UI Elements"}</strong></span>
                    <span style={{ fontSize: "10px", marginLeft: "4px" }}>{isAnalysisDropdownOpen ? "▲" : "▼"}</span>
                  </button>

                  {isAnalysisDropdownOpen && (
                    <div
                      style={{
                        position: "absolute",
                        top: "calc(100% + 6px)",
                        left: 0,
                        background: "#0f172a",
                        border: "1px solid #334155",
                        borderRadius: "8px",
                        padding: "6px",
                        minWidth: "220px",
                        boxShadow: "0 12px 30px rgba(0, 0, 0, 0.75)",
                        zIndex: 1000,
                        display: "flex",
                        flexDirection: "column",
                        gap: "4px"
                      }}
                    >
                      {[
                        { id: "sam", label: "1. UI Elements (SAM)" },
                        { id: "ocr", label: "2. Extracted Text (OCR)" },
                        { id: "colors", label: "3. Color Palette" },
                        { id: "json", label: "4. UI Structure (JSON)" },
                        { id: "similarity", label: "5. Accuracy Check" },
                      ].map((subTab) => (
                        <button
                          key={subTab.id}
                          type="button"
                          onClick={() => {
                            setActiveUiTab("analysis");
                            setActiveAnalysisSubTab(subTab.id);
                            setIsAnalysisDropdownOpen(false);
                          }}
                          style={{
                            display: "flex",
                            alignItems: "center",
                            justifyContent: "space-between",
                            gap: "8px",
                            padding: "8px 12px",
                            borderRadius: "5px",
                            border: "none",
                            background: activeUiTab === "analysis" && activeAnalysisSubTab === subTab.id ? "#1e293b" : "transparent",
                            color: activeUiTab === "analysis" && activeAnalysisSubTab === subTab.id ? "#38bdf8" : "#cbd5e1",
                            fontSize: "12px",
                            fontWeight: activeUiTab === "analysis" && activeAnalysisSubTab === subTab.id ? "700" : "500",
                            textAlign: "left",
                            cursor: "pointer"
                          }}
                        >
                          <span>{subTab.label}</span>
                          {activeUiTab === "analysis" && activeAnalysisSubTab === subTab.id && (
                            <span style={{ color: "#38bdf8", fontSize: "12px" }}>✓</span>
                          )}
                        </button>
                      ))}
                    </div>
                  )}
                </div>

                {/* 2. CODE & PREVIEW DROPDOWN */}
                <div style={{ position: "relative" }} ref={codeDropdownRef}>
                  <button
                    type="button"
                    onClick={() => {
                      setActiveUiTab("generated_code");
                      setIsCodeDropdownOpen((prev) => !prev);
                      setIsAnalysisDropdownOpen(false);
                    }}
                    style={{
                      display: "flex",
                      alignItems: "center",
                      gap: "8px",
                      padding: "8px 14px",
                      borderRadius: "6px",
                      cursor: "pointer",
                      fontSize: "12.5px",
                      fontWeight: activeUiTab === "generated_code" ? "700" : "500",
                      background: activeUiTab === "generated_code" ? "#1e293b" : "#0f172a",
                      color: activeUiTab === "generated_code" ? "#38bdf8" : "#94a3b8",
                      border: activeUiTab === "generated_code" ? "1px solid #38bdf8" : "1px solid #334155",
                      boxShadow: activeUiTab === "generated_code" ? "0 2px 10px rgba(56, 189, 248, 0.2)" : "none",
                      transition: "all 0.2s ease"
                    }}
                  >
                    <span></span>
                    <span>Code & Preview: <strong style={{ color: "#f8fafc" }}>{activeCodeSubTab === "html" ? "HTML / CSS" : "Flutter"}</strong></span>
                    <span style={{ fontSize: "10px", marginLeft: "4px" }}>{isCodeDropdownOpen ? "▲" : "▼"}</span>
                  </button>

                  {isCodeDropdownOpen && (
                    <div
                      style={{
                        position: "absolute",
                        top: "calc(100% + 6px)",
                        left: 0,
                        background: "#0f172a",
                        border: "1px solid #334155",
                        borderRadius: "8px",
                        padding: "6px",
                        minWidth: "240px",
                        boxShadow: "0 12px 30px rgba(0, 0, 0, 0.75)",
                        zIndex: 1000,
                        display: "flex",
                        flexDirection: "column",
                        gap: "4px"
                      }}
                    >
                      {/* Sub-option: HTML */}
                      <button
                        type="button"
                        onClick={() => {
                          setActiveUiTab("generated_code");
                          setActiveCodeSubTab("html");
                          setIsCodeDropdownOpen(false);
                        }}
                        style={{
                          display: "flex",
                          alignItems: "center",
                          justifyContent: "space-between",
                          gap: "8px",
                          padding: "8px 12px",
                          borderRadius: "5px",
                          border: "none",
                          background: activeUiTab === "generated_code" && activeCodeSubTab === "html" ? "#1e293b" : "transparent",
                          color: activeUiTab === "generated_code" && activeCodeSubTab === "html" ? "#38bdf8" : "#cbd5e1",
                          fontSize: "12px",
                          fontWeight: activeUiTab === "generated_code" && activeCodeSubTab === "html" ? "700" : "500",
                          textAlign: "left",
                          cursor: "pointer"
                        }}
                      >
                        <span> HTML / CSS Code</span>
                        {activeUiTab === "generated_code" && activeCodeSubTab === "html" && (
                          <span style={{ color: "#38bdf8", fontSize: "12px" }}>✓</span>
                        )}
                      </button>

                      {/* Sub-option: Flutter */}
                      <button
                        type="button"
                        onClick={() => {
                          setActiveUiTab("generated_code");
                          setActiveCodeSubTab("flutter");
                          setIsCodeDropdownOpen(false);
                        }}
                        style={{
                          display: "flex",
                          alignItems: "center",
                          justifyContent: "space-between",
                          gap: "8px",
                          padding: "8px 12px",
                          borderRadius: "5px",
                          border: "none",
                          background: activeUiTab === "generated_code" && activeCodeSubTab === "flutter" ? "#1e293b" : "transparent",
                          color: activeUiTab === "generated_code" && activeCodeSubTab === "flutter" ? "#38bdf8" : "#cbd5e1",
                          fontSize: "12px",
                          fontWeight: activeUiTab === "generated_code" && activeCodeSubTab === "flutter" ? "700" : "500",
                          textAlign: "left",
                          cursor: "pointer"
                        }}
                      >
                        <span> Flutter Code</span>
                        {activeUiTab === "generated_code" && activeCodeSubTab === "flutter" && (
                          <span style={{ color: "#38bdf8", fontSize: "12px" }}>✓</span>
                        )}
                      </button>

                      <div style={{ height: "1px", background: "#334155", margin: "4px 0" }} />

                      {/* Split View Toggle Option */}
                      <button
                        type="button"
                        onClick={() => {
                          setActiveUiTab("generated_code");
                          setIsSideBySidePreview((prev) => !prev);
                          setIsCodeDropdownOpen(false);
                        }}
                        style={{
                          display: "flex",
                          alignItems: "center",
                          justifyContent: "space-between",
                          gap: "8px",
                          padding: "8px 12px",
                          borderRadius: "5px",
                          border: "none",
                          background: isSideBySidePreview ? "#0284c725" : "transparent",
                          color: isSideBySidePreview ? "#38bdf8" : "#cbd5e1",
                          fontSize: "12px",
                          fontWeight: isSideBySidePreview ? "700" : "500",
                          textAlign: "left",
                          cursor: "pointer"
                        }}
                      >
                        <span>◫ Split View (Code + Live Preview)</span>
                        <span style={{
                          fontSize: "10px",
                          padding: "2px 6px",
                          borderRadius: "4px",
                          background: isSideBySidePreview ? "#0284c7" : "#334155",
                          color: "#fff"
                        }}>
                          {isSideBySidePreview ? "ENABLED" : "OFF"}
                        </span>
                      </button>
                    </div>
                  )}
                </div>

              </div>

              {/* Contextual Action Buttons in Header */}
              <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                {activeUiTab === "analysis" && activeAnalysisSubTab === "json" && uiJsonOutput && (
                  <button className="copy-btn" onClick={() => copyToClipboard(uiJsonOutput)} style={{ position: "static", margin: 0 }}>
                    Copy UI Structure
                  </button>
                )}
                {activeUiTab === "analysis" && activeAnalysisSubTab === "ocr" && ocrOutput && (
                  <button className="copy-btn" onClick={() => copyToClipboard(JSON.stringify(ocrOutput, null, 2))} style={{ position: "static", margin: 0 }}>
                    Copy Extracted Text
                  </button>
                )}

                {activeUiTab === "generated_code" && activeCodeSubTab === "flutter" && uiFlutterOutput && (
                  <button
                    className="copy-btn"
                    onClick={openInDartPad}
                    style={{ margin: 0, position: "static", background: "#059669", color: "#ffffff" }}
                    title="Open code directly inside interactive Google DartPad runner"
                  >
                     Open in Live Playground
                  </button>
                )}
                {activeUiTab === "generated_code" && activeCodeSubTab === "html" && uiHtmlOutput && (
                  <button
                    className="copy-btn"
                    onClick={() => copyToClipboard(uiHtmlOutput)}
                    style={{ margin: 0, position: "static" }}
                  >
                    Copy HTML Code
                  </button>
                )}
                {activeUiTab === "generated_code" && activeCodeSubTab === "flutter" && uiFlutterOutput && (
                  <button
                    className="copy-btn"
                    onClick={() => copyToClipboard(uiFlutterOutput)}
                    style={{ margin: 0, position: "static" }}
                  >
                    Copy Flutter Code
                  </button>
                )}
              </div>
            </div>

            <div className="tab-viewport" style={{ flex: 1, minHeight: 0, overflow: "hidden", display: "flex", flexDirection: "column" }}>
              {/* =======================================================
                  MAIN TAB 1 VIEWPORT: IMAGE ANALYSIS
                  ======================================================= */}
              {activeUiTab === "analysis" && (
                <div style={{ display: "flex", flexDirection: "column", height: "100%", width: "100%", overflow: "hidden", minHeight: 0 }}>

                  {/* 1. UI Elements View */}
                  {activeAnalysisSubTab === "sam" && (
                    <div className="viewport-content centered-flex" style={{ flex: 1, minHeight: 0, overflowY: "auto" }}>
                      {samPreview ? (
                        <div className="segmented-preview-container">
                          <img src={samPreview} alt="Detected UI elements layout output" className="segmented-img" />
                        </div>
                      ) : (
                        <div className="empty-state">
                          <span className="empty-icon"></span>
                          <p>Detected UI elements layout results will render here after execution.</p>
                        </div>
                      )}
                    </div>
                  )}

                  {/* 2. Extracted Text Output */}
                  {activeAnalysisSubTab === "ocr" && (
                    <div className="viewport-content code-layout" style={{ flex: 1, minHeight: 0, overflowY: "auto", position: "relative" }}>
                      {ocrOutput ? (
                        <pre className="code-block" style={{ margin: 0 }}>
                          <code>{JSON.stringify(ocrOutput, null, 2)}</code>
                        </pre>
                      ) : (
                        <div className="empty-state">
                          <span className="empty-icon"></span>
                          <p>Text extracted from the screen will render here.</p>
                        </div>
                      )}
                    </div>
                  )}

                  {/* 3. Color Palette Output */}
                  {activeAnalysisSubTab === "colors" && (
                    <div className="viewport-content centered-flex" style={{ flex: 1, minHeight: 0, overflowY: "auto" }}>
                      {colorsOutput && colorsOutput.length > 0 ? (
                        <div className="colors-grid">
                          {colorsOutput.map((color, idx) => (
                            <div key={idx} className="color-swatch-card">
                              <div className="color-preview-circle" style={{ backgroundColor: color }}></div>
                              <div className="color-meta-info">
                                <span className="color-swatch-id">ID: {idx}</span>
                                <span className="color-swatch-hex">{color}</span>
                              </div>
                            </div>
                          ))}
                        </div>
                      ) : (
                        <div className="empty-state">
                          <span className="empty-icon"></span>
                          <p>Extracted hexadecimal design colors will display here.</p>
                        </div>
                      )}
                    </div>
                  )}

                  {/* 4. UI Structure Output */}
                  {activeAnalysisSubTab === "json" && (
                    <div className="viewport-content code-layout" style={{ flex: 1, minHeight: 0, overflowY: "auto", position: "relative" }}>
                      {uiJsonOutput ? (
                        <pre className="code-block" style={{ margin: 0 }}>
                          <code>{uiJsonOutput}</code>
                        </pre>
                      ) : (
                        <div className="empty-state">
                          <span className="empty-icon"></span>
                          <p>Generated UI structure hierarchy will render here.</p>
                        </div>
                      )}
                    </div>
                  )}

                  {/* 5. Accuracy Check Output */}
                  {activeAnalysisSubTab === "similarity" && (
                    <div
                      className="viewport-content"
                      style={{
                        flex: 1,
                        minHeight: 0,
                        overflowY: "auto",
                        padding: "20px",
                        display: "block"
                      }}
                    >
                      {similarityOutput ? (
                        <div className="similarity-container" style={{ display: "flex", flexDirection: "column", gap: "20px", minHeight: "min-content" }}>
                         
                          {/* Accuracy Engine Status & Relevance Card */}
                          {irEvaluationResult && (
                            <div style={{
                              background: "#1e293b",
                              border: "1px solid #334155",
                              borderRadius: "8px",
                              padding: "16px"
                            }}>
                              <h4 style={{ color: "#38bdf8", margin: "0 0 10px 0" }}>Accuracy & Match Telemetry</h4>
                              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: "10px", marginBottom: "12px" }}>
                                <div>
                                  <span style={{ fontSize: "10.5px", color: "#94a3b8" }}>STATUS</span>
                                  <div style={{ fontWeight: "bold", color: irEvaluationResult.status === "FULL_MATCH" ? "#34d399" : "#f59e0b" }}>{irEvaluationResult.status}</div>
                                </div>
                                <div>
                                  <span style={{ fontSize: "10.5px", color: "#94a3b8" }}>RELEVANCE SCORE</span>
                                  <div style={{ fontWeight: "bold", color: "#38bdf8" }}>{Math.round(irEvaluationResult.relevance * 100)}%</div>
                                </div>
                                <div>
                                  <span style={{ fontSize: "10.5px", color: "#94a3b8" }}>COVERAGE SCORE</span>
                                  <div style={{ fontWeight: "bold", color: "#38bdf8" }}>{Math.round(irEvaluationResult.coverage * 100)}%</div>
                                </div>
                              </div>
                              {irEvaluationResult.unresolved && irEvaluationResult.unresolved.length > 0 && (
                                <div style={{ borderTop: "1px dashed #334155", paddingTop: "8px" }}>
                                  <span style={{ fontSize: "10px", color: "#f87171", fontWeight: "bold" }}>UNRESOLVED REQUIREMENTS:</span>
                                  <ul style={{ margin: "4px 0 0 16px", padding: 0, fontSize: "11px", color: "#cbd5e1" }}>
                                    {irEvaluationResult.unresolved.map((u, i) => <li key={i}>{u}</li>)}
                                  </ul>
                                </div>
                              )}
                            </div>
                          )}

                          {/* Visual Match Quality Ring */}
                          {clipSimilarity !== null && (
                            <div className="visual-alignment-metrics" style={{
                              background: "#1e293b",
                              border: "1px solid #334155",
                              borderRadius: "8px",
                              padding: "20px",
                              textAlign: "center"
                            }}>
                              <h3 style={{ margin: "0 0 10px 0", color: "#f8fafc", fontSize: "16px" }}>Reconstruction Quality</h3>
                              <div style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: "15px" }}>
                                <div className="progress-circle-indicator" style={{
                                  position: "relative",
                                  width: "120px",
                                  height: "120px",
                                  borderRadius: "50%",
                                  background: `conic-gradient(#10b981 ${clipSimilarity * 3.6}deg, #334155 0deg)`,
                                  display: "flex",
                                  alignItems: "center",
                                  justifyContent: "center"
                                }}>
                                  <div style={{
                                    width: "100px",
                                    height: "100px",
                                    borderRadius: "50%",
                                    background: "#1e293b",
                                    display: "flex",
                                    alignItems: "center",
                                    justifyContent: "center",
                                    flexDirection: "column"
                                  }}>
                                    <span style={{ color: "#34d399", fontSize: "24px", fontWeight: "bold" }}>{clipSimilarity}%</span>
                                    <span style={{ color: "#94a3b8", fontSize: "9px", textTransform: "uppercase" }}>Visual Match</span>
                                  </div>
                                </div>
                               
                                <div style={{ textAlign: "left" }}>
                                  <h4 style={{ color: "#38bdf8", margin: "0 0 5px 0" }}>Semantic Visual Verification</h4>
                                  <p style={{ color: "#94a3b8", fontSize: "12px", margin: "0", maxWidth: "400px" }}>
                                    Evaluates structural similarities and color themes between original source inputs and compiled HTML outputs.
                                  </p>
                                </div>
                              </div>
                            </div>
                          )}

                          {/* Render Visual Comparison Side-by-Side */}
                          {htmlRenderPreview && imagePreview && (
                            <div className="visual-side-by-side" style={{
                              display: "grid",
                              gridTemplateColumns: "1fr 1fr",
                              gap: "15px",
                            }}>
                              <div style={{ background: "#1e293b", border: "1px solid #334155", borderRadius: "8px", padding: "10px" }}>
                                <h4 style={{ color: "#94a3b8", margin: "0 0 8px 0", textAlign: "center", fontSize: "12px" }}>ORIGINAL INPUT VIEW</h4>
                                <img src={imagePreview} alt="Original input mockup" style={{ width: "100%", height: "auto", maxHeight: "400px", objectFit: "contain", borderRadius: "4px" }} />
                              </div>
                             
                              <div style={{ background: "#1e293b", border: "1px solid #334155", borderRadius: "8px", padding: "10px" }}>
                                <h4 style={{ color: "#94a3b8", margin: "0 0 8px 0", textAlign: "center", fontSize: "12px" }}>RENDERED MOCKUP</h4>
                                <img src={htmlRenderPreview} alt="Rendered preview mockup" style={{ width: "100%", height: "auto", maxHeight: "400px", objectFit: "contain", borderRadius: "4px" }} />
                              </div>
                            </div>
                          )}

                          <div className="similarity-card" style={{ width: "100%" }}>
                            <h3 style={{ marginBottom: "15px", color: "#f8fafc", fontSize: "14px" }}>Design Matching & Retrieval Log</h3>
                            <pre style={{
                              backgroundColor: "#0f172a",
                              padding: "15px",
                              borderRadius: "6px",
                              border: "1px solid #334155",
                              color: "#38bdf8",
                              fontFamily: "monospace",
                              fontSize: "12px",
                              lineHeight: "1.5",
                              whiteSpace: "pre-wrap",
                              overflowX: "auto"
                            }}>
                              <code>{similarityOutput}</code>
                            </pre>
                          </div>
                        </div>
                      ) : (
                        <div className="empty-state">
                          <span className="empty-icon"></span>
                          <p>Visual accuracy check and matching logs will display here.</p>
                        </div>
                      )}
                    </div>
                  )}

                </div>
              )}

              {/* =======================================================
                  MAIN TAB 2 VIEWPORT: CODE & PREVIEW
                  ======================================================= */}
              {activeUiTab === "generated_code" && (
                <div className="viewport-content code-layout" style={{ display: "flex", flexDirection: "column", height: "100%", minHeight: 0, padding: 0 }}>

                  {/* Code & Live Preview Layout Area */}
                  <div style={{
                    flex: 1,
                    minHeight: 0,
                    overflow: "hidden",
                    display: isSideBySidePreview ? "grid" : "block",
                    gridTemplateColumns: isSideBySidePreview ? "1fr 1fr" : "1fr",
                    height: "100%"
                  }}>
                   
                    {/* LEFT PANE: SOURCE CODE DISPLAY */}
                    <div style={{
                      height: "100%",
                      minHeight: 0,
                      overflowY: "auto",
                      padding: "16px",
                      borderRight: isSideBySidePreview ? "1px solid #334155" : "none"
                    }}>
                      {activeCodeSubTab === "html" ? (
                        uiHtmlOutput ? (
                          <pre className="code-block" style={{ margin: 0 }}>
                            <code>{uiHtmlOutput}</code>
                          </pre>
                        ) : (
                          <div className="empty-state">
                            <span className="empty-icon"></span>
                            <p>Generated semantic HTML5 structural layout and CSS code will render here.</p>
                          </div>
                        )
                      ) : (
                        uiFlutterOutput ? (
                          <pre className="code-block" style={{ margin: 0 }}>
                            <code>{uiFlutterOutput}</code>
                          </pre>
                        ) : (
                          <div className="empty-state">
                            <span className="empty-icon"></span>
                            <p>Generated Dart/Flutter widgets implementation code will render here.</p>
                          </div>
                        )
                      )}
                    </div>

                    {/* RIGHT PANE: LIVE SIDE-BY-SIDE COMPILER & PREVIEW */}
                    {isSideBySidePreview && (
                      <div style={{
                        height: "100%",
                        minHeight: 0,
                        display: "flex",
                        flexDirection: "column",
                        background: "#020617",
                        overflow: "hidden"
                      }}>
                        <div style={{
                          padding: "6px 14px",
                          background: "#0b1329",
                          borderBottom: "1px solid #334155",
                          fontSize: "11px",
                          color: "#94a3b8",
                          fontWeight: "bold",
                          display: "flex",
                          justifyContent: "space-between",
                          flexShrink: 0
                        }}>
                          <span>LIVE COMPILER PREVIEW</span>
                          <span>{activeCodeSubTab === "html" ? "Live Web Preview" : "Mobile App Preview"}</span>
                        </div>

                        {/* Preview Scrollable Viewport */}
                        <div style={{ flex: 1, minHeight: 0, padding: "14px", overflowY: "auto" }}>
                          {activeCodeSubTab === "html" ? (
                            uiHtmlOutput ? (
                              <iframe
                                title="Live Web Preview"
                                srcDoc={uiHtmlOutput}
                                sandbox="allow-scripts"
                                style={{
                                  width: "100%",
                                  height: "100%",
                                  minHeight: "520px",
                                  backgroundColor: "#ffffff",
                                  border: "1px solid #334155",
                                  borderRadius: "6px"
                                }}
                              />
                            ) : (
                              <div className="empty-state">
                                <p>Awaiting HTML code generation to mount live preview...</p>
                              </div>
                            )
                          ) : (
                            /* Flutter Preview Pane */
                            <div style={{ display: "flex", flexDirection: "column", gap: "14px", minHeight: "min-content" }}>
                              {htmlRenderPreview ? (
                                <div style={{ background: "#1e293b", padding: "14px", borderRadius: "8px", border: "1px solid #334155", textAlign: "center" }}>
                                  <span style={{ fontSize: "11px", color: "#38bdf8", fontWeight: "bold", display: "block", marginBottom: "8px" }}>
                                    RENDERED MOCKUP
                                  </span>
                                  <img
                                    src={htmlRenderPreview}
                                    alt="Compiled UI visual preview"
                                    style={{ width: "100%", height: "auto", borderRadius: "4px", objectFit: "contain", boxShadow: "0 4px 12px rgba(0,0,0,0.4)" }}
                                  />
                                </div>
                              ) : (
                                <div style={{ background: "#1e293b", padding: "16px", borderRadius: "8px", border: "1px dashed #334155", textAlign: "center" }}>
                                  <p style={{ color: "#94a3b8", fontSize: "12px", margin: 0 }}>
                                    Snapshot will appear here once the pipeline renders the visual alignment check.
                                  </p>
                                </div>
                              )}

                              <div style={{ background: "#0f172a", padding: "16px", borderRadius: "8px", border: "1px solid #334155", color: "#cbd5e1", fontSize: "12px", lineHeight: "1.5" }}>
                                <h4 style={{ color: "#38bdf8", margin: "0 0 6px 0", fontSize: "13px" }}>⚡ Interactive Flutter Sandbox</h4>
                                <p style={{ margin: "0 0 12px 0", color: "#94a3b8" }}>
                                  Flutter widgets compile through the Skia/Impeller engine. Launch the interactive editor in DartPad to test and interact with this widget in real-time:
                                </p>
                                <button
                                  onClick={openInDartPad}
                                  disabled={!uiFlutterOutput}
                                  style={{
                                    width: "100%",
                                    padding: "10px 14px",
                                    borderRadius: "5px",
                                    background: "#0284c7",
                                    color: "#ffffff",
                                    border: "none",
                                    fontWeight: "bold",
                                    fontSize: "12px",
                                    cursor: uiFlutterOutput ? "pointer" : "not-allowed",
                                    opacity: uiFlutterOutput ? 1 : 0.5,
                                    display: "flex",
                                    alignItems: "center",
                                    justifyContent: "center",
                                    gap: "8px"
                                  }}
                                >
                                  <span></span> Open in Live Playground
                                </button>
                              </div>
                            </div>
                          )}
                        </div>
                      </div>
                    )}

                  </div>

                </div>
              )}
            </div>
          </section>
        </main>
      )}

      {/* =======================================================
          MODAL: ZIP ARCHIVE IMAGE SELECTION GALLERY
          ======================================================= */}
      {isZipModalOpen && (
        <div
          style={{
            position: "fixed",
            top: 0,
            left: 0,
            width: "100vw",
            height: "100vh",
            backgroundColor: "rgba(0, 0, 0, 0.82)",
            backdropFilter: "blur(6px)",
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
            zIndex: 10006
          }}
          onClick={() => setIsZipModalOpen(false)}
        >
          <div
            style={{
              backgroundColor: "#0f172a",
              border: "1px solid #38bdf8",
              borderRadius: "12px",
              width: "880px",
              maxWidth: "94vw",
              height: "82vh",
              padding: "20px",
              boxShadow: "0 25px 50px rgba(0, 0, 0, 0.8)",
              display: "flex",
              flexDirection: "column",
              gap: "14px",
              color: "#f8fafc",
              overflow: "hidden"
            }}
            onClick={(e) => e.stopPropagation()}
          >
            {/* Modal Header */}
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", borderBottom: "1px solid #334155", paddingBottom: "12px" }}>
              <div>
                <h3 style={{ margin: 0, color: "#38bdf8", fontSize: "17px", display: "flex", alignItems: "center", gap: "8px" }}>
                  <span></span> Select UI Mockup from ZIP Archive
                </h3>
                <span style={{ fontSize: "12px", color: "#94a3b8", marginTop: "3px", display: "block" }}>
                  Archive: <strong>{zipFileName}</strong> • Found <strong>{zipImages.length}</strong> image screens
                </span>
              </div>
              <button
                onClick={() => setIsZipModalOpen(false)}
                style={{ background: "transparent", border: "none", color: "#94a3b8", fontSize: "20px", cursor: "pointer" }}
              >
                ✕
              </button>
            </div>

            {/* Search Filter Bar */}
            <div style={{ display: "flex", gap: "10px", alignItems: "center" }}>
              <input
                type="text"
                value={zipSearchQuery}
                onChange={(e) => setZipSearchQuery(e.target.value)}
                placeholder="Search screen by name (e.g. login, dashboard, checkout)..."
                style={{
                  flex: 1,
                  padding: "8px 12px",
                  borderRadius: "6px",
                  border: "1px solid #334155",
                  background: "#020617",
                  color: "#f8fafc",
                  fontSize: "12.5px",
                  outline: "none"
                }}
              />
              <span style={{ fontSize: "11.5px", color: "#94a3b8" }}>
                Showing {filteredZipImages.length} of {zipImages.length}
              </span>
            </div>

            {/* Image Grid Gallery Viewport */}
            <div
              style={{
                flex: 1,
                minHeight: 0,
                overflowY: "auto",
                display: "grid",
                gridTemplateColumns: "repeat(auto-fill, minmax(190px, 1fr))",
                gap: "14px",
                padding: "4px",
                alignContent: "start"
              }}
            >
              {filteredZipImages.map((imgItem, idx) => {
                const isSelected = selectedFile?.name === imgItem.name;
                return (
                  <div
                    key={idx}
                    onClick={() => handleSelectImageFromZip(imgItem)}
                    style={{
                      backgroundColor: isSelected ? "#0369a130" : "#1e293b",
                      border: isSelected ? "2px solid #38bdf8" : "1px solid #334155",
                      borderRadius: "8px",
                      padding: "10px",
                      cursor: "pointer",
                      display: "flex",
                      flexDirection: "column",
                      gap: "8px",
                      boxShadow: isSelected ? "0 0 12px rgba(56, 189, 248, 0.35)" : "0 4px 10px rgba(0,0,0,0.3)",
                      transition: "transform 0.15s ease, border-color 0.15s ease"
                    }}
                    onMouseEnter={(e) => {
                      if (!isSelected) e.currentTarget.style.borderColor = "#38bdf8";
                      e.currentTarget.style.transform = "translateY(-2px)";
                    }}
                    onMouseLeave={(e) => {
                      if (!isSelected) e.currentTarget.style.borderColor = "#334155";
                      e.currentTarget.style.transform = "translateY(0)";
                    }}
                  >
                    {/* Thumbnail Box */}
                    <div
                      style={{
                        width: "100%",
                        height: "135px",
                        background: "#0b1329",
                        borderRadius: "5px",
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "center",
                        overflow: "hidden",
                        position: "relative"
                      }}
                    >
                      <img
                        src={imgItem.previewUrl}
                        alt={imgItem.name}
                        style={{ maxWidth: "100%", maxHeight: "100%", objectFit: "contain" }}
                      />
                      {isSelected && (
                        <span style={{
                          position: "absolute",
                          top: "6px",
                          right: "6px",
                          background: "#0284c7",
                          color: "#fff",
                          fontSize: "10px",
                          fontWeight: "bold",
                          padding: "2px 6px",
                          borderRadius: "4px"
                        }}>
                          ACTIVE
                        </span>
                      )}
                    </div>

                    {/* Meta: File Name */}
                    <div style={{ fontSize: "12px", color: "#f8fafc", fontWeight: "600", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }} title={imgItem.name}>
                      {imgItem.name}
                    </div>

                    {/* Meta: Dimensions & File Size */}
                    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", fontSize: "11px", color: "#94a3b8" }}>
                      <span style={{ background: "#0f172a", padding: "2px 5px", borderRadius: "3px" }}>
                        {imgItem.dimensions}
                      </span>
                      <span style={{ color: "#38bdf8", fontWeight: "600" }}>
                        {imgItem.sizeFormatted}
                      </span>
                    </div>

                    <button
                      type="button"
                      onClick={(e) => {
                        e.stopPropagation();
                        handleSelectImageFromZip(imgItem);
                      }}
                      style={{
                        width: "100%",
                        padding: "6px",
                        background: isSelected ? "#0284c7" : "#334155",
                        color: "#ffffff",
                        border: "none",
                        borderRadius: "4px",
                        fontSize: "11px",
                        fontWeight: "bold",
                        cursor: "pointer",
                        marginTop: "2px"
                      }}
                    >
                      {isSelected ? "✓ Selected Screen" : "Use this screen"}
                    </button>
                  </div>
                );
              })}
            </div>

            {/* Modal Footer */}
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", borderTop: "1px solid #334155", paddingTop: "12px" }}>
              <span style={{ fontSize: "12px", color: "#94a3b8" }}>
                 Click any screen above to load it into the engine preview.
              </span>
              <button
                type="button"
                onClick={() => setIsZipModalOpen(false)}
                style={{
                  background: "#334155",
                  border: "none",
                  color: "#f8fafc",
                  padding: "7px 16px",
                  borderRadius: "5px",
                  cursor: "pointer",
                  fontSize: "12px",
                  fontWeight: "600"
                }}
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}

      {/* =======================================================
          WORKSPACE 2: FIGMA TO CODE COMPILER WORKSPACE
          ======================================================= */}
      {workspace === "figma" && (
        <div className="figma-grid-view">
         
          {/* Left Inputs/Paster Area */}
          <div className="figma-input-side">
            {/* Step 1 Form */}
            <div className="step-card">
              <div className="step-header">
                <span className="step-badge">1</span>
                <h3>Extract Raw Figma JSON (API Link)</h3>
                <span className="step-status">{step1Message}</span>
              </div>
              <form onSubmit={handleExtractSubmit} className="figma-form">
                <div className="form-row">
                  <label>Personal Access Token:</label>
                  <input
                    type="password"
                    value={figmaToken}
                    onChange={(e) => setFigmaToken(e.target.value)}
                    placeholder="Figma Token..."
                    className="figma-input"
                  />
                </div>
                <div className="form-row">
                  <label>Figma File Key</label>
                  <input
                    type="text"
                    value={fileKey}
                    onChange={(e) => setFileKey(e.target.value)}
                    placeholder="File Key..."
                    className="figma-input"
                  />
                </div>
                <button type="submit" disabled={step1Status === "loading"} className="action-btn-primary">
                  {step1Status === "loading" ? "Fetching..." : "Fetch File Schema"}
                </button>
              </form>

              {extractedRawJson && (
                <div className="form-row">
                  <div className="flex-row-justify">
                    <label>Raw Output:</label>
                    <button className="copy-btn-small" onClick={() => copyToClipboard(extractedRawJson)}>Copy JSON</button>
                  </div>
                  <textarea readOnly value={extractedRawJson} className="figma-raw-output-textarea" />
                </div>
              )}
            </div>

            {/* Step 2 Form */}
            <div className="step-card">
              <div className="step-header">
                <span className="step-badge">2</span>
                <h3>Paste & Compile JSON</h3>
              </div>
              <div className="figma-form">
                <div className="form-row">
                  <label>Figma Schema JSON:</label>
                  <textarea
                    value={pastedJson}
                    onChange={(e) => handlePastedJsonChange(e.target.value)}
                    placeholder="Paste figma json here or use fetched output..."
                    className="figma-textarea"
                  />
                </div>
                {figmaJsonError && <div className="json-error-log">{figmaJsonError}</div>}
                {imageAssetMessage && <div className="json-success-log">{imageAssetMessage}</div>}
              </div>
            </div>
          </div>

          {/* Right Output Workspace Grid */}
          <div className="figma-output-side">
            <div className="figma-configuration-bar">
              <div className="config-group">
                <label>Component Name:</label>
                <input
                  type="text"
                  value={figmaFileName}
                  onChange={(e) => setFigmaFileName(e.target.value)}
                  placeholder="ComponentName"
                  className="dashboard-input"
                />
              </div>

              <div className="config-group">
                <label>Target Language:</label>
                <select
                  value={figmaFormat}
                  onChange={(e) => setFigmaFormat(e.target.value)}
                  className="dashboard-select"
                >
                  <option value="html">HTML / CSS</option>
                  <option value="flutter">Flutter Dart</option>
                  <option value="react">React Tailwind</option>
                </select>
              </div>
            </div>

            {/* Split Preview and Code Area */}
            <div className="figma-splits-container">
              <div className="split-view left-split">
                <div className="split-header">Figma Page Navigator</div>
                <div className="split-body">
                  <div className="pages-selection-list">
                    {figmaPages.map((page) => (
                      <button
                        key={page.id}
                        className={`page-select-btn ${activeFigmaPageId === page.id ? "selected" : ""}`}
                        onClick={() => setActiveFigmaPageId(page.id)}
                      >
                        📄 {page.name}
                      </button>
                    ))}
                  </div>
                  <div className="interactive-canvas">
                    <FigmaPreview activePage={activeFigmaPage} />
                  </div>
                </div>
              </div>

              <div className="split-view right-split">
                <div className="split-tab-triggers">
                  <button
                    className={`split-tab-btn ${activeFigmaTab === "compiler" ? "active" : ""}`}
                    onClick={() => setActiveFigmaTab("compiler")}
                  >
                     Standard AST Compiler
                  </button>
                  <button
                    className={`split-tab-btn ${activeFigmaTab === "ai" ? "active" : ""}`}
                    onClick={() => setActiveFigmaTab("ai")}
                  >
                     Gemini LLM Refined
                  </button>
                </div>

                <div className="split-tab-body">
                  {activeFigmaTab === "compiler" && (
                    <div className="viewport-content code-layout">
                      {figmaCompilerCode ? (
                        <>
                          <button className="copy-btn" onClick={() => copyToClipboard(figmaCompilerCode)}>Copy Compiled Code</button>
                          <pre className="code-block">
                            <code>{figmaCompilerCode}</code>
                          </pre>
                        </>
                      ) : (
                        <div className="empty-state">
                          <p>Figma Standard AST compiled outputs will display here.</p>
                        </div>
                      )}
                    </div>
                  )}

                  {activeFigmaTab === "ai" && (
                    <div className="viewport-content code-layout">
                      {isFigmaAiLoading ? (
                        <div className="centered-flex" style={{ height: "100%" }}>
                          <p className="log-text">Gemini Studio API is synthesizing code...</p>
                        </div>
                      ) : figmaAiError ? (
                        <div className="centered-flex" style={{ height: "100%" }}>
                          <p className="log-text">❌ Error: {figmaAiError}</p>
                        </div>
                      ) : activeFigmaPage && figmaAiCodeCache[activeFigmaPage.id] ? (
                        <>
                          <button className="copy-btn" onClick={() => copyToClipboard(figmaAiCodeCache[activeFigmaPage.id])}>Copy Synthesized Code</button>
                          <pre className="code-block">
                            <code>{figmaAiCodeCache[activeFigmaPage.id]}</code>
                          </pre>
                        </>
                      ) : (
                        <div className="empty-state">
                          <p>Gemini LLM model synthesized layouts will display here.</p>
                        </div>
                      )}
                    </div>
                  )}
                </div>
              </div>

            </div>
          </div>

        </div>
      )}

      {/* =======================================================
          WORKSPACE 3: JIRA CONNECTOR WORKSPACE
          ======================================================= */}
      {workspace === "jira" && (
        <div style={{ padding: "30px", height: "calc(100vh - 80px)", overflowY: "auto", background: "#0b1329" }}>
          <div style={{ maxWidth: "880px", margin: "0 auto", background: "#0f172a", border: "1px solid #334155", borderRadius: "10px", padding: "28px", boxShadow: "0 10px 30px rgba(0,0,0,0.5)" }}>
            <div style={{ display: "flex", alignItems: "center", gap: "12px", borderBottom: "1px solid #1e293b", paddingBottom: "16px", marginBottom: "20px" }}>
              <span style={{ fontSize: "28px" }}>📋</span>
              <div>
                <h2 style={{ margin: 0, color: "#38bdf8", fontSize: "18px" }}>Atlassian Jira Connector</h2>
                <p style={{ margin: "4px 0 0 0", color: "#94a3b8", fontSize: "12px" }}>
                  Connect Jira Software Epics, Stories, and UI Acceptance Criteria directly into the Code Generation Pipeline.
                </p>
              </div>
            </div>

            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px", marginBottom: "20px" }}>
              <div>
                <label style={{ display: "block", color: "#cbd5e1", fontSize: "12px", marginBottom: "6px" }}>Jira Domain / Host URL:</label>
                <input
                  type="text"
                  placeholder="https://your-domain.atlassian.net"
                  className="dashboard-input"
                  style={{ width: "100%", padding: "10px", borderRadius: "6px", background: "#020617", border: "1px solid #334155", color: "#fff" }}
                />
              </div>

              <div>
                <label style={{ display: "block", color: "#cbd5e1", fontSize: "12px", marginBottom: "6px" }}>Issue Key or Board Filter:</label>
                <input
                  type="text"
                  placeholder="e.g. PROJ-1024 or sprint=active"
                  className="dashboard-input"
                  style={{ width: "100%", padding: "10px", borderRadius: "6px", background: "#020617", border: "1px solid #334155", color: "#fff" }}
                />
              </div>
            </div>

            <div style={{ marginBottom: "20px" }}>
              <label style={{ display: "block", color: "#cbd5e1", fontSize: "12px", marginBottom: "6px" }}>API Access Token / Service Credential:</label>
              <input
                type="password"
                placeholder="Enter Jira Personal Access Token"
                className="dashboard-input"
                style={{ width: "100%", padding: "10px", borderRadius: "6px", background: "#020617", border: "1px solid #334155", color: "#fff" }}
              />
            </div>

            <div style={{ background: "#111c38", border: "1px solid #1e293b", borderRadius: "6px", padding: "16px", marginBottom: "20px" }}>
              <h4 style={{ margin: "0 0 8px 0", color: "#f59e0b", fontSize: "13px" }}>⚡ Jira Acceptance & Story Parser Features:</h4>
              <ul style={{ margin: 0, paddingLeft: "18px", color: "#94a3b8", fontSize: "12px", lineHeight: "1.6" }}>
                <li>Extract Gherkin user stories & acceptance criteria to enforce layout validation.</li>
                <li>Link image designs to active Jira issues for automated compliance testing.</li>
                <li>Direct pipeline sync back to Jira work tickets upon pull-request generation.</li>
              </ul>
            </div>

            <button
              type="button"
              onClick={() => alert("Jira connector configured. Ready for issue tracking synchronization.")}
              style={{
                background: "linear-gradient(135deg, #0284c7, #0369a1)",
                color: "#ffffff",
                border: "none",
                borderRadius: "6px",
                padding: "11px 20px",
                fontSize: "13px",
                fontWeight: "bold",
                cursor: "pointer"
              }}
            >
              Connect Jira Project
            </button>
          </div>
        </div>
      )}

      {/* =======================================================
          NON-BLOCKING MODAL: INSUFFICIENT RETRIEVAL COVERAGE
          ======================================================= */}
      {isMatchModalOpen && (
        <div
          style={{
            position: "fixed",
            top: 0,
            left: 0,
            width: "100vw",
            height: "100vh",
            backgroundColor: "rgba(0, 0, 0, 0.75)",
            backdropFilter: "blur(4px)",
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
            zIndex: 10000
          }}
        >
          <div
            style={{
              backgroundColor: "#0f172a",
              border: "1px solid #38bdf8",
              borderRadius: "10px",
              width: "500px",
              maxWidth: "92vw",
              padding: "24px",
              boxShadow: "0 20px 45px rgba(0, 0, 0, 0.8)",
              color: "#f8fafc"
            }}
          >
            <h3 style={{ margin: "0 0 12px 0", color: "#f59e0b", fontSize: "16px" }}>
              ⚠️ Insufficient Retrieval Coverage
            </h3>
           
            <p style={{ fontSize: "13px", lineHeight: "1.5", color: "#cbd5e1" }}>
              The Knowledge Repo does not contain enough matching evidence for this request.
              <br /><br />
              <strong>Status:</strong> {irEvaluationResult?.status}
              <br />
              <strong>Relevance Score:</strong> {Math.round((irEvaluationResult?.relevance || 0) * 100)}% | <strong>Coverage:</strong> {Math.round((irEvaluationResult?.coverage || 0) * 100)}%
              <br /><br />
              Would you like to build or enrich the Knowledge Repo before proceeding?
            </p>

            <div style={{ display: "flex", justifyContent: "flex-end", gap: "10px", marginTop: "20px" }}>
              <button
                onClick={handleDecisionContinueAi}
                style={{
                  background: "#334155",
                  border: "none",
                  color: "#cbd5e1",
                  borderRadius: "6px",
                  padding: "9px 15px",
                  fontSize: "12px",
                  fontWeight: "bold",
                  cursor: "pointer"
                }}
              >
                No, Continue with AI
              </button>

              <button
                onClick={handleDecisionEnrichRepo}
                style={{
                  background: "#0284c7",
                  border: "none",
                  color: "#ffffff",
                  borderRadius: "6px",
                  padding: "9px 15px",
                  fontSize: "12px",
                  fontWeight: "bold",
                  cursor: "pointer"
                }}
              >
                Yes, Build/Update Repo
              </button>
            </div>
          </div>
        </div>
      )}

      {/* =======================================================
          MODAL 1: INGESTED KNOWLEDGE BASE INSPECTOR
          ======================================================= */}
      {isKnowledgeBaseOpen && (
        <div
          style={{
            position: "fixed",
            top: 0,
            left: 0,
            width: "100vw",
            height: "100vh",
            backgroundColor: "rgba(0, 0, 0, 0.8)",
            backdropFilter: "blur(5px)",
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
            zIndex: 10001
          }}
          onClick={() => setIsKnowledgeBaseOpen(false)}
        >
          <div
            style={{
              backgroundColor: "#0f172a",
              border: "1px solid #38bdf8",
              borderRadius: "10px",
              width: "650px",
              maxWidth: "92vw",
              maxHeight: "85vh",
              padding: "24px",
              boxShadow: "0 20px 45px rgba(0, 0, 0, 0.7)",
              display: "flex",
              flexDirection: "column",
              gap: "16px",
              color: "#f8fafc",
              overflow: "hidden"
            }}
            onClick={(e) => e.stopPropagation()}
          >
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", borderBottom: "1px solid #334155", paddingBottom: "12px" }}>
              <h3 style={{ margin: 0, fontSize: "16px", color: "#38bdf8", display: "flex", alignItems: "center", gap: "8px" }}>
                <span></span> Ingested Knowledge Base Repository
              </h3>
              <button
                onClick={() => setIsKnowledgeBaseOpen(false)}
                style={{
                  background: "transparent",
                  border: "none",
                  color: "#94a3b8",
                  fontSize: "18px",
                  cursor: "pointer"
                }}
              >
                ✕
              </button>
            </div>

            <div role="tablist" aria-label="Knowledge source" style={{ display: "grid", gridTemplateColumns: "repeat(4, minmax(0, 1fr))", gap: "8px" }}>
              {[
                ["zip", "UI Images"],
                ["doc", "Documents"],
                ["github", "GitHub Repo"],
                ["sql", "Local SQL DB"]
              ].map(([tab, label]) => (
                <button
                  key={tab}
                  type="button"
                  role="tab"
                  aria-selected={kbTab === tab}
                  onClick={() => { setKbTab(tab); setKbMessage(null); }}
                  style={{
                    padding: "9px 6px",
                    border: kbTab === tab ? "1px solid #38bdf8" : "1px solid #334155",
                    borderRadius: "4px",
                    background: kbTab === tab ? "#1e293b" : "#0f172a",
                    color: kbTab === tab ? "#38bdf8" : "#94a3b8",
                    fontSize: "12px",
                    cursor: "pointer",
                  }}
                >
                  {label}
                </button>
              ))}
            </div>

            {kbTab === "zip" && (
              <div>
                <label htmlFor="kb-zip" style={{ display: "block", marginBottom: "6px", color: "#cbd5e1", fontSize: "12px" }}>
                  UI screenshots archive (.zip)
                </label>
                <input id="kb-zip" type="file" accept=".zip" disabled={kbLoading} onChange={(event) => handleKbFileUpload(event, "ingest_zip")} />
              </div>
            )}

            {kbTab === "doc" && (
              <div>
                <label htmlFor="kb-document" style={{ display: "block", marginBottom: "6px", color: "#cbd5e1", fontSize: "12px" }}>
                  Design specifications (.pdf, .xlsx, .xls, .csv)
                </label>
                <input id="kb-document" type="file" accept=".pdf,.xlsx,.xls,.csv" disabled={kbLoading} onChange={(event) => handleKbFileUpload(event, "ingest_doc")} />
              </div>
            )}

            {kbTab === "sql" && (
              <div>
                <label htmlFor="kb-sql" style={{ display: "block", marginBottom: "6px", color: "#cbd5e1", fontSize: "12px" }}>
                  Local Database / Schemas (.sqlite, .db, .sql dump)
                </label>
                <input id="kb-sql" type="file" accept=".sqlite,.db,.sqlite3,.sql" disabled={kbLoading} onChange={(event) => handleKbFileUpload(event, "ingest_sql")} />
                <p style={{ margin: "6px 0 0 0", fontSize: "11px", color: "#94a3b8", lineHeight: "1.4" }}>
                  💡 <strong>Local SQLite Advantage:</strong> Zero external database setup needed. Automatically indexes tables, DDL schemas, foreign key definitions, and row samples into ChromaDB.
                </p>
              </div>
            )}

            {kbTab === "github" && (
              <form onSubmit={handleGithubIngest} style={{ display: "flex", flexWrap: "wrap", gap: "8px" }}>
                <label htmlFor="kb-github-url" style={{ width: "100%", color: "#cbd5e1", fontSize: "12px" }}>
                  Public GitHub repository URL
                </label>
                <input
                  id="kb-github-url"
                  type="url"
                  required
                  value={githubUrl}
                  onChange={(event) => setGithubUrl(event.target.value)}
                  placeholder="https://github.com/owner/repository"
                  disabled={kbLoading}
                  style={{ flex: "1 1 260px", minWidth: 0, padding: "8px", border: "1px solid #475569", borderRadius: "4px", background: "#020617", color: "#f8fafc" }}
                />
                <button type="submit" disabled={kbLoading} style={{ padding: "8px 12px", border: 0, borderRadius: "4px", background: "#0284c7", color: "white", cursor: kbLoading ? "wait" : "pointer" }}>
                  {kbLoading ? "Indexing..." : "Index repository"}
                </button>
              </form>
            )}

            {kbMessage && (
              <p role="status" aria-live="polite" style={{ margin: 0, color: kbMessage.type === "error" ? "#f87171" : kbMessage.type === "success" ? "#34d399" : "#38bdf8", fontSize: "12px" }}>
                {kbMessage.text}
              </p>
            )}

            {/* Content Body */}
            <div style={{ flex: 1, overflowY: "auto", display: "flex", flexDirection: "column", gap: "16px" }}>
              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "10px" }}>
                <div style={{ backgroundColor: "#1e293b", padding: "10px", borderRadius: "6px", border: "1px solid #334155" }}>
                  <span style={{ fontSize: "10.5px", color: "#94a3b8", textTransform: "uppercase" }}>Ingestion Status</span>
                  <div style={{ fontSize: "12px", color: "#34d399", fontWeight: "bold", marginTop: "4px" }}>
                    {uiJsonOutput ? "✓ Ingested & Indexed in DB" : "Awaiting Input Image Upload"}
                  </div>
                </div>
                <div style={{ backgroundColor: "#1e293b", padding: "10px", borderRadius: "6px", border: "1px solid #334155" }}>
                  <span style={{ fontSize: "10.5px", color: "#94a3b8", textTransform: "uppercase" }}>Embedding Vector</span>
                  <div style={{ fontSize: "12px", color: "#38bdf8", fontWeight: "bold", marginTop: "4px" }}>
                    {uiJsonOutput ? "896-Dim Multi-modal Coordinates" : "None"}
                  </div>
                </div>
              </div>

              {imagePreview && (
                <div>
                  <span style={{ fontSize: "11px", color: "#94a3b8", fontWeight: "bold", display: "block", marginBottom: "6px" }}>
                    CURRENT INGESTED IMAGE BLUEPRINT:
                  </span>
                  <div style={{ display: "flex", gap: "12px", alignItems: "center", background: "#1e293b", padding: "10px", borderRadius: "6px", border: "1px solid #334155" }}>
                    <img src={imagePreview} alt="Knowledge preview" style={{ height: "70px", borderRadius: "4px", border: "1px solid #475569" }} />
                    <div style={{ fontSize: "11px", color: "#cbd5e1", lineHeight: "1.4" }}>
                      <div><strong>File:</strong> {selectedFile ? selectedFile.name : "Custom UI Screen"}</div>
                      <div><strong>Color Nodes Extracted:</strong> {colorsOutput.length}</div>
                      <div><strong>OCR Strings Extracted:</strong> {ocrOutput ? ocrOutput.length : 0}</div>
                    </div>
                  </div>
                </div>
              )}

              <div>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "6px" }}>
                  <span style={{ fontSize: "11px", color: "#f59e0b", fontWeight: "bold" }}>
                    EXTRACTED UI STRUCTURE:
                  </span>
                  {uiJsonOutput && (
                    <button
                      onClick={() => copyToClipboard(uiJsonOutput)}
                      style={{ background: "#334155", color: "#38bdf8", border: "none", borderRadius: "4px", padding: "2px 8px", fontSize: "10px", cursor: "pointer" }}
                    >
                      Copy UI Structure
                    </button>
                  )}
                </div>
                <pre style={{
                  backgroundColor: "#020617",
                  padding: "12px",
                  borderRadius: "6px",
                  border: "1px solid #334155",
                  color: "#38bdf8",
                  fontFamily: "monospace",
                  fontSize: "11px",
                  maxHeight: "180px",
                  overflowY: "auto"
                }}>
                  <code>{uiJsonOutput || "// No UI JSON blueprint loaded. Upload and run the pipeline to ingest knowledge."}</code>
                </pre>
              </div>

            </div>

            {/* Footer */}
            <div style={{ display: "flex", justifyContent: "flex-end", borderTop: "1px solid #334155", paddingTop: "12px" }}>
              <button
                onClick={() => setIsKnowledgeBaseOpen(false)}
                style={{
                  backgroundColor: "#0284c7",
                  color: "#ffffff",
                  border: "none",
                  borderRadius: "6px",
                  padding: "8px 16px",
                  fontSize: "12px",
                  fontWeight: "bold",
                  cursor: "pointer"
                }}
              >
                Close Repository
              </button>
            </div>
          </div>
        </div>
      )}

      {/* =======================================================
          MODAL 2: SYNTHESIS ENGINE DETAILS (ELABORATED TELEMETRY)
          ======================================================= */}
      {isEngineModalOpen && (
        <div
          style={{
            position: "fixed",
            top: 0,
            left: 0,
            width: "100vw",
            height: "100vh",
            backgroundColor: "rgba(0, 0, 0, 0.75)",
            backdropFilter: "blur(4px)",
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
            zIndex: 9999
          }}
          onClick={() => setIsEngineModalOpen(false)}
        >
          <div
            style={{
              backgroundColor: "#0f172a",
              border: "1px solid #334155",
              borderRadius: "10px",
              width: "560px",
              maxWidth: "92vw",
              padding: "24px",
              boxShadow: "0 20px 40px rgba(0, 0, 0, 0.6)",
              display: "flex",
              flexDirection: "column",
              gap: "16px",
              color: "#f8fafc"
            }}
            onClick={(e) => e.stopPropagation()}
          >
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", borderBottom: "1px solid #334155", paddingBottom: "12px" }}>
              <h3 style={{ margin: 0, fontSize: "16px", color: "#38bdf8", display: "flex", alignItems: "center", gap: "8px" }}>
                <span>⚡</span> Synthesis Engine Architecture & Telemetry
              </h3>
              <button
                onClick={() => setIsEngineModalOpen(false)}
                style={{
                  background: "transparent",
                  border: "none",
                  color: "#94a3b8",
                  fontSize: "18px",
                  cursor: "pointer",
                  lineHeight: "1"
                }}
              >
                ✕
              </button>
            </div>

            <div>
              <span style={{ fontSize: "11px", color: "#94a3b8", textTransform: "uppercase", fontWeight: "bold" }}>
                Active Model Tier & Engine
              </span>
              <div style={{
                marginTop: "6px",
                padding: "8px 12px",
                backgroundColor: "#1e293b",
                borderRadius: "6px",
                border: "1px solid #0284c7",
                color: "#38bdf8",
                fontWeight: "bold",
                fontFamily: "monospace",
                fontSize: "14px"
              }}>
                {selectedModelEngine}
              </div>
            </div>

            <div>
              <span style={{ fontSize: "11px", color: "#f59e0b", textTransform: "uppercase", fontWeight: "bold" }}>
                Synthesis Pipeline Architectural Context
              </span>
              <div style={{
                marginTop: "6px",
                padding: "12px",
                backgroundColor: "#1e293b",
                borderRadius: "6px",
                border: "1px solid #334155",
                color: "#cbd5e1",
                fontSize: "12px",
                lineHeight: "1.6"
              }}>
                <p style={{ margin: "0 0 8px 0" }}>
                  <strong>Dynamic Multi-Modal Orchestration:</strong> The Synthesis Engine couples <em>Segment Anything (SAM)</em> layout decomposition with <em>EasyOCR</em> typography mapping, <em>Nemotron-3</em> layout vectors, and <em>CLIP ViT-B/32</em> visual alignment.
                </p>
                <p style={{ margin: "0 0 8px 0" }}>
                  <strong>Hierarchical DesignIR Mapping:</strong> Instead of guessing code from pixel grids, the engine parses bounding-box coordinates into an enriched AST container tree. It resolves parent-child containment, responsive margins, and semantic element types (containers, buttons, inputs, labels).
                </p>
                <p style={{ margin: "0 0 8px 0" }}>
                  <strong>Local Knowledge Integration:</strong> Searches the indexed ChromaDB knowledge base (UI components, specifications, documents, and local SQL schemas) before invoking generative models, avoiding hallucination and promoting verified enterprise code.
                </p>
                <div style={{ borderTop: "1px dashed #334155", paddingTop: "8px", marginTop: "8px", color: "#38bdf8" }}>
                  <strong>Active Rationale:</strong> {modelSelectionReason}
                </div>
              </div>
            </div>

            <div style={{ display: "flex", justifyContent: "flex-end", marginTop: "8px" }}>
              <button
                onClick={() => setIsEngineModalOpen(false)}
                style={{
                  backgroundColor: "#0284c7",
                  color: "#ffffff",
                  border: "none",
                  borderRadius: "6px",
                  padding: "8px 16px",
                  fontSize: "12px",
                  fontWeight: "bold",
                  cursor: "pointer"
                }}
              >
                Close Window
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default App