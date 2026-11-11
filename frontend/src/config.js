import axios from "axios";

// Central API configuration for the frontend.
// Backend URL resolution order:
//   1. ?api=<url> query param (persisted on first load, then stripped)
//   2. localStorage override (set via the header's API editor)
//   3. VITE_API_URL (build-time env var, set in Netlify / .env)
//   4. http://localhost:8000 (local dev)
// VITE_API_KEY is build-time only and never changes across redeploys.

const LS_KEY = "firstkut_api_url";

function normalizeUrl(url) {
  return (url || "").trim().replace(/\/+$/, "");
}

function readQueryUrl() {
  try {
    return normalizeUrl(new URLSearchParams(window.location.search).get("api"));
  } catch {
    return "";
  }
}

function readStoredUrl() {
  try {
    return normalizeUrl(localStorage.getItem(LS_KEY));
  } catch {
    return "";
  }
}

function resolveApiUrl() {
  const fromQuery = readQueryUrl();
  if (fromQuery) {
    try {
      localStorage.setItem(LS_KEY, fromQuery);
      const url = new URL(window.location.href);
      url.searchParams.delete("api");
      window.history.replaceState({}, "", url);
    } catch {
      /* ignore */
    }
    return fromQuery;
  }
  const stored = readStoredUrl();
  if (stored) return stored;
  return normalizeUrl(import.meta.env.VITE_API_URL || "http://localhost:8000");
}

export const API = resolveApiUrl();
export const API_KEY = (import.meta.env.VITE_API_KEY || "").trim();

// Merge the shared API key (when the backend requires one) into request headers.
export function apiHeaders(extra = {}) {
  return API_KEY ? { ...extra, "x-api-key": API_KEY } : { ...extra };
}

// Verify a backend URL via /health, then persist it as the runtime override.
// Returns { ok: true } or { ok: false, error }.
export async function saveApiUrl(url) {
  const target = normalizeUrl(url);
  if (!/^https?:\/\/.+/.test(target)) {
    return { ok: false, error: "URL must start with http:// or https://" };
  }
  try {
    const res = await axios.get(`${target}/health`, { timeout: 10000 });
    if (!res.data || res.data.status !== "ok") {
      return { ok: false, error: `Health check failed: ${JSON.stringify(res.data)}` };
    }
  } catch (e) {
    return {
      ok: false,
      error: `Health check failed: ${e.response ? `HTTP ${e.response.status}` : e.message}`,
    };
  }
  try {
    localStorage.setItem(LS_KEY, target);
  } catch {
    return { ok: false, error: "Browser blocked localStorage; cannot persist URL" };
  }
  return { ok: true };
}

// Drop the runtime override and fall back to the build-time default.
export function resetApiUrl() {
  try {
    localStorage.removeItem(LS_KEY);
  } catch {
    /* ignore */
  }
}

// Poll a backend job until it finishes. onUpdate receives every intermediate
// snapshot so the UI can render live stage progress.
export async function pollJob(jobId, onUpdate, { intervalMs = 1500, maxAttempts = 600 } = {}) {
  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    const res = await axios.get(`${API}/api/jobs/${jobId}`, {
      headers: apiHeaders(),
      timeout: 30000,
    });
    const job = res.data;
    if (onUpdate) onUpdate(job);

    if (job.status === "completed") return job;
    if (job.status === "failed") throw new Error(job.error || "Job failed on the server");

    await new Promise((resolve) => setTimeout(resolve, intervalMs));
  }
  throw new Error("Job timed out while polling for results");
}
