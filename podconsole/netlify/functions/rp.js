const REST_BASE = "https://rest.runpod.io/v1";
const V2_BASE = "https://api.runpod.io/v2";

let localConfig = {};
try {
  localConfig = require("./config.json");
} catch (_) {}

const RUNPOD_API_KEY = process.env.RUNPOD_API_KEY || localConfig.RUNPOD_API_KEY;
const CONSOLE_PASSPHRASE = process.env.CONSOLE_PASSPHRASE || localConfig.CONSOLE_PASSPHRASE;

const HEALTH_URL_RE = /^https:\/\/[a-z0-9-]+-\d+\.proxy\.runpod\.net$/;
const REST_PATH_RE = /^\/(pods|templates|networkvolumes|billing)(\/|$|\?)/;

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "content-type,x-console-pass",
  "Access-Control-Allow-Methods": "GET,POST,PATCH,DELETE,OPTIONS",
};

function json(statusCode, payload) {
  return {
    statusCode,
    headers: { ...CORS, "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  };
}

function relay(resp) {
  return resp.text().then((text) => ({
    statusCode: resp.status,
    headers: { ...CORS, "Content-Type": "application/json" },
    body: text || "{}",
  }));
}

exports.handler = async (event) => {
  if (event.httpMethod === "OPTIONS") {
    return { statusCode: 204, headers: CORS, body: "" };
  }
  if (!RUNPOD_API_KEY || !CONSOLE_PASSPHRASE) {
    return json(500, { error: "server config missing (RUNPOD_API_KEY / CONSOLE_PASSPHRASE)" });
  }

  const h = event.headers || {};
  const supplied = h["x-console-pass"] || h["X-Console-Pass"] || "";
  if (supplied !== CONSOLE_PASSPHRASE) {
    return json(401, { error: "invalid passphrase" });
  }

  let req = {};
  try {
    req = event.body ? JSON.parse(event.body) : {};
  } catch (_) {
    return json(400, { error: "invalid JSON body" });
  }

  const target = req.target || "rest";
  const path = req.path || "/";
  const method = (req.method || "GET").toUpperCase();

  try {
    if (target === "health") {
      if (!HEALTH_URL_RE.test(path)) return json(400, { error: "invalid health url" });
      const r = await fetch(path + "/health", {
        headers: { "User-Agent": "curl/8.5.0" },
      });
      return relay(r);
    }

    if (target === "v2") {
      if (method !== "GET" || !path.startsWith("/catalog/gpus")) {
        return json(403, { error: "v2 target allows GET /catalog/gpus only" });
      }
      const r = await fetch(V2_BASE + path, {
        headers: {
          Authorization: "Bearer " + RUNPOD_API_KEY,
          "User-Agent": "curl/8.5.0",
        },
      });
      return relay(r);
    }

    if (!["GET", "POST", "PATCH", "DELETE"].includes(method)) {
      return json(405, { error: "method not allowed" });
    }
    if (!REST_PATH_RE.test(path)) {
      return json(403, { error: "path outside allowed REST resources" });
    }

    const opts = {
      method,
      headers: {
        Authorization: "Bearer " + RUNPOD_API_KEY,
        "User-Agent": "curl/8.5.0",
      },
    };
    if (method !== "GET" && method !== "DELETE" && req.body !== undefined) {
      opts.headers["Content-Type"] = "application/json";
      opts.body = JSON.stringify(req.body);
    }
    const r = await fetch(REST_BASE + path, opts);
    return relay(r);
  } catch (e) {
    return json(502, { error: String((e && e.message) || e) });
  }
};
