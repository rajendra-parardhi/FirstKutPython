import axios from "axios";

// Central API configuration for the frontend.
// VITE_API_URL / VITE_API_KEY are build-time env vars (set them in Netlify / .env).

export const API = (import.meta.env.VITE_API_URL || "http://localhost:8000").replace(/\/+$/, "");
export const API_KEY = (import.meta.env.VITE_API_KEY || "").trim();

// Merge the shared API key (when the backend requires one) into request headers.
export function apiHeaders(extra = {}) {
  return API_KEY ? { ...extra, "x-api-key": API_KEY } : { ...extra };
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
