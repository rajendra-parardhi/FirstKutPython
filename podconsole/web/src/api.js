const PASS_KEY = "pc_pass";

export function getPass() {
  return sessionStorage.getItem(PASS_KEY) || "";
}

export function setPass(p) {
  sessionStorage.setItem(PASS_KEY, p);
}

export function clearPass() {
  sessionStorage.removeItem(PASS_KEY);
}

// Low-level call: returns { status, data } without throwing on HTTP errors.
export async function call(target, path, method = "GET", body) {
  const res = await fetch("/.netlify/functions/rp", {
    method: "POST",
    headers: {
      "content-type": "application/json",
      "x-console-pass": getPass(),
    },
    body: JSON.stringify({ target, path, method, body }),
  });
  const text = await res.text();
  let data = {};
  try {
    data = text ? JSON.parse(text) : {};
  } catch {
    data = { raw: text };
  }
  return { status: res.status, data };
}

// Unwraps a successful call or throws Error(status + message).
export function must(r) {
  if (r.status >= 400) {
    const m =
      r.data.error || r.data.message || r.data.detail || JSON.stringify(r.data).slice(0, 200);
    const e = new Error(typeof m === "string" ? m : JSON.stringify(m));
    e.status = r.status;
    throw e;
  }
  return r.data;
}

export const rest = (path, method = "GET", body) => call("rest", path, method, body);
export const restOk = (path, method = "GET", body) => must(rest(path, method, body));

export const catalog = () =>
  must(
    call(
      "v2",
      "/catalog/gpus?include=AVAILABILITY&product=POD&cloud=SECURE&count=1&countryCodes=US,CA",
      "GET"
    )
  );

export const health = (podId) => call("health", proxyUrl(podId), "GET");

export function proxyUrl(podId) {
  return `https://${podId}-8000.proxy.runpod.net`;
}

export function siteUrl(podId) {
  return `https://firstkut-ui.netlify.app/?api=${encodeURIComponent(proxyUrl(podId))}`;
}
