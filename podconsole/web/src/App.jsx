import React, { useState, useRef, useEffect, useCallback } from "react";
import {
  getPass,
  setPass,
  clearPass,
  rest,
  restOk,
  catalog,
  health,
  proxyUrl,
  siteUrl,
} from "./api";

const TEMPLATE_ID = "eoczodltog";
const VOLUME_ID = "ijq0e4gos3";
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

function catalogRows(cat) {
  return (cat.gpus || []).flatMap((g) =>
    (g.dataCenters || []).map((dc) => ({
      id: g.id,
      mem: g.memory || 0,
      price: (g.price && (g.price.secure ?? g.price.minimumBid)) ?? 999,
      dc: dc.id,
      avail: dc.availability,
    }))
  );
}

function qualRows(cat, eff, volumeDc) {
  return catalogRows(cat)
    .filter((r) => r.mem >= eff.minVram && r.avail !== "NONE")
    .filter((r) => (eff.keepData ? r.dc === volumeDc : true));
}

function candidates(cat, eff, volumeDc) {
  return qualRows(cat, eff, volumeDc)
    .filter((r) => r.price <= eff.cap)
    .sort((a, b) => {
      if (a.id === eff.preferred) return -1;
      if (b.id === eff.preferred) return 1;
      return a.price - b.price;
    });
}

function escalationFor(cat, eff, volumeDc) {
  if (!cat) return { kind: "unknown" };
  const q = qualRows(cat, eff, volumeDc).sort((a, b) => a.price - b.price);
  if (q.length === 0) {
    return { kind: "none-any", keepData: eff.keepData, minVram: eff.minVram, dc: volumeDc };
  }
  if (q[0].price <= eff.cap) return { kind: "flaky", cheapest: q[0] };
  const suggested = Math.ceil(q[0].price / 0.25) * 0.25;
  return {
    kind: "raise",
    cap: eff.cap,
    cheapest: q[0],
    suggested,
    unlocks: q.filter((r) => r.price <= suggested).slice(0, 5),
  };
}

function buildBody(cand, eff) {
  return {
    name: "firstkut-api",
    templateId: TEMPLATE_ID,
    gpuTypeIds: [cand.id],
    dataCenterIds: [cand.dc],
    containerDiskInGb: 50,
    cloudType: "SECURE",
    ...(eff.keepData ? { networkVolumeId: VOLUME_ID, volumeMountPath: "/data" } : {}),
  };
}

function App() {
  const [passIn, setPassIn] = useState("");
  const [authed, setAuthed] = useState(!!getPass());
  const [loginErr, setLoginErr] = useState("");
  const [busyLogin, setBusyLogin] = useState(false);

  const [pods, setPods] = useState([]);
  const [podsErr, setPodsErr] = useState("");
  const [loadingPods, setLoadingPods] = useState(false);
  const [healthMap, setHealthMap] = useState({});
  const [actBusy, setActBusy] = useState("");
  const [confirmTerm, setConfirmTerm] = useState("");
  const [copied, setCopied] = useState("");

  const [volumeDc, setVolumeDc] = useState("");
  const [volumeErr, setVolumeErr] = useState("");

  const [cfg, setCfg] = useState({
    minVram: "16",
    cap: "0.5",
    minutes: "12",
    preferred: "NVIDIA RTX A5000",
    keepData: true,
  });
  const [scan, setScan] = useState({ active: false, log: [], escalation: null, created: null });
  const [escCap, setEscCap] = useState("");
  const cancelRef = useRef({ v: false });

  const loadPods = useCallback(async () => {
    setLoadingPods(true);
    setPodsErr("");
    try {
      const data = await restOk("/pods");
      setPods(Array.isArray(data) ? data : data.pods || []);
    } catch (e) {
      setPodsErr(e.message);
    }
    setLoadingPods(false);
  }, []);

  useEffect(() => {
    if (!authed) return;
    loadPods();
    restOk(`/networkvolumes/${VOLUME_ID}`)
      .then((v) => setVolumeDc(v.dataCenterId || ""))
      .catch((e) => setVolumeErr(e.message));
  }, [authed, loadPods]);

  useEffect(() => {
    if (scan.escalation && scan.escalation.suggested) {
      setEscCap(String(scan.escalation.suggested));
    }
  }, [scan.escalation]);

  async function login(e) {
    e.preventDefault();
    setBusyLogin(true);
    setLoginErr("");
    setPass(passIn.trim());
    try {
      await restOk("/pods");
      setAuthed(true);
    } catch (err) {
      clearPass();
      setLoginErr(err.status === 401 ? "Wrong passphrase" : err.message);
    }
    setBusyLogin(false);
  }

  function logout() {
    clearPass();
    setAuthed(false);
    setPods([]);
  }

  async function ping(id) {
    setHealthMap((m) => ({ ...m, [id]: "…" }));
    const r = await health(id);
    setHealthMap((m) => ({
      ...m,
      [id]: r.status === 200 && r.data && r.data.status === "ok" ? "ok" : `HTTP ${r.status}`,
    }));
  }

  async function podAction(pod, action) {
    const key = `${pod.id}:${action}`;
    setActBusy(key);
    try {
      if (action === "terminate") await restOk(`/pods/${pod.id}`, "DELETE");
      else await restOk(`/pods/${pod.id}/${action}`, "POST");
      setConfirmTerm("");
      await loadPods();
    } catch (e) {
      setPodsErr(`${action} failed: ${e.message}`);
    }
    setActBusy("");
  }

  function copyUrl(id) {
    navigator.clipboard?.writeText(proxyUrl(id));
    setCopied(id);
    setTimeout(() => setCopied(""), 1500);
  }

  function startScan(overrideCap) {
    const cap = overrideCap !== undefined ? Number(overrideCap) : Number(cfg.cap);
    const eff = {
      minVram: Number(cfg.minVram) || 16,
      cap: cap || 0.5,
      minutes: Math.min(60, Math.max(1, Number(cfg.minutes) || 12)),
      preferred: (cfg.preferred || "").trim(),
      keepData: cfg.keepData,
    };
    cancelRef.current = { v: false };
    const cancel = cancelRef.current;
    const mine = () => cancelRef.current === cancel && !cancel.v;
    setScan({ active: true, log: [], escalation: null, created: null });
    const log = (m) => {
      if (!mine()) return;
      setScan((s) => ({ ...s, log: [...s.log, `${new Date().toLocaleTimeString()}  ${m}`] }));
    };

    const deadline = Date.now() + eff.minutes * 60000;
    log(
      `scan: prefer=${eff.preferred || "(cheapest)"} min=${eff.minVram}GB cap=$${eff.cap}/hr window=${eff.minutes}min ` +
        `${eff.keepData ? `keep-data@${volumeDc || "?"}` : "any-DC (no volume)"}`
    );

    (async () => {
      let cat = null;
      while (!cancel.v && Date.now() < deadline) {
        try {
          cat = await catalog();
        } catch (e) {
          log(`catalog error: ${e.message}`);
          await sleep(15000);
          continue;
        }

        const pool = candidates(cat, eff, volumeDc);
        if (pool.length === 0) {
          const q = qualRows(cat, eff, volumeDc).sort((a, b) => a.price - b.price);
          if (q.length === 0) {
            log(`no >=${eff.minVram}GB GPU ${eff.keepData ? `at ${volumeDc}` : "anywhere"} at any price - waiting...`);
          } else {
            log(`nothing <= $${eff.cap}/hr - cheapest: ${q[0].id} $${q[0].price} @ ${q[0].dc}`);
          }
        } else {
          log(
            `candidates: ${pool.slice(0, 3).map((c) => `${c.id} $${c.price}`).join(" | ")}` +
              `${pool.length > 3 ? ` (+${pool.length - 3})` : ""}`
          );
          for (const cand of pool) {
            if (cancel.v || !mine()) break;
            log(`trying ${cand.id} @ ${cand.dc} $${cand.price}...`);
            const r = await rest("/pods", "POST", buildBody(cand, eff));
            if (!mine()) break;
            if (r.status > 0 && r.status < 300) {
              log(`POD CREATED: ${r.data.id} (${cand.id})`);
              setScan((s) => ({ ...s, created: { pod: r.data, cand } }));
              loadPods();
              cancel.v = true;
              break;
            }
            const msg = String(
              (r.data && (r.data.message || r.data.detail || r.data.error)) ||
                JSON.stringify(r.data)
            ).slice(0, 160);
            log(`failed ${cand.id}: HTTP ${r.status} ${msg}`);
            if (r.status === 402) {
              log("INSUFFICIENT BALANCE - top up Runpod credit.");
              cancel.v = true;
              break;
            }
          }
        }
        if (cancel.v || !mine()) break;
        const remaining = deadline - Date.now();
        if (remaining <= 0) break;
        await sleep(Math.min(15000, Math.max(1000, remaining)));
      }

      if (cancelRef.current !== cancel) return;
      if (!cancel.v) {
        const esc = escalationFor(cat, eff, volumeDc);
        setScan((s) => ({
          ...s,
          active: false,
          escalation: esc,
          log: [...s.log, `${new Date().toLocaleTimeString()}  time window elapsed - pick an option below`],
        }));
      } else {
        setScan((s) => ({ ...s, active: false }));
      }
    })();
  }

  function stopScan() {
    cancelRef.current.v = true;
    setScan((s) => ({ ...s, active: false, log: [...s.log, `${new Date().toLocaleTimeString()}  scan stopped`] }));
  }

  if (!authed) {
    return (
      <div className="login-wrap">
        <form className="login-card" onSubmit={login}>
          <h1>Pod Console</h1>
          <p className="muted">Runpod start / stop + smart GPU scan</p>
          <input
            type="password"
            placeholder="Passphrase"
            value={passIn}
            onChange={(e) => setPassIn(e.target.value)}
            autoFocus
          />
          <button className="btn primary" disabled={busyLogin || !passIn.trim()}>
            {busyLogin ? "Checking..." : "Enter"}
          </button>
          {loginErr && <p className="err">{loginErr}</p>}
        </form>
      </div>
    );
  }

  const esc = scan.escalation;

  return (
    <div className="app">
      <header className="top">
        <h1>Pod Console</h1>
        <div className="spacer" />
        <span className="muted">{volumeDc ? `volume DC: ${volumeDc}` : volumeErr ? `volume: ${volumeErr}` : "volume: ..."}</span>
        <button className="btn" onClick={logout}>Log out</button>
      </header>

      <main className="grid">
        <section className="panel">
          <div className="panel-head">
            <h2>Smart launch</h2>
            {scan.active ? (
              <button className="btn danger" onClick={stopScan}>Stop scan</button>
            ) : (
              <button className="btn primary" onClick={() => startScan()}>Start scan</button>
            )}
          </div>

          <div className="form">
            <label>
              Preferred GPU
              <input
                value={cfg.preferred}
                placeholder="NVIDIA RTX A5000 (blank = cheapest)"
                onChange={(e) => setCfg({ ...cfg, preferred: e.target.value })}
              />
            </label>
            <div className="row2">
              <label>
                Min VRAM (GB)
                <input
                  type="number"
                  min="1"
                  value={cfg.minVram}
                  onChange={(e) => setCfg({ ...cfg, minVram: e.target.value })}
                />
              </label>
              <label>
                Max $/hr
                <input
                  type="number"
                  min="0.05"
                  step="0.05"
                  value={cfg.cap}
                  onChange={(e) => setCfg({ ...cfg, cap: e.target.value })}
                />
              </label>
              <label>
                Scan (min)
                <input
                  type="number"
                  min="1"
                  max="60"
                  value={cfg.minutes}
                  onChange={(e) => setCfg({ ...cfg, minutes: e.target.value })}
                />
              </label>
            </div>
            <label className="check">
              <input
                type="checkbox"
                checked={cfg.keepData}
                onChange={(e) => setCfg({ ...cfg, keepData: e.target.checked })}
              />
              Keep data (volume {VOLUME_ID} @ {volumeDc || "?"} - pod must be in this DC)
            </label>
            {!cfg.keepData && (
              <p className="warn">Any-DC mode: new pod gets NO volume - vector DB data will not carry over.</p>
            )}
          </div>

          {scan.created && (
            <div className="card ok">
              <strong>Pod created: {scan.created.pod.id}</strong>
              <div className="muted">{scan.created.cand.id} @ {scan.created.cand.dc}</div>
              <div className="btn-row">
                <button className="btn" onClick={() => copyUrl(scan.created.pod.id)}>
                  {copied === scan.created.pod.id ? "Copied!" : "Copy URL"}
                </button>
                <a className="btn" href={siteUrl(scan.created.pod.id)} target="_blank" rel="noreferrer">
                  Open app
                </a>
                <button className="btn" onClick={() => ping(scan.created.pod.id)}>Health</button>
                <span className={`badge ${healthMap[scan.created.pod.id] === "ok" ? "good" : ""}`}>
                  {healthMap[scan.created.pod.id] || ""}
                </span>
              </div>
            </div>
          )}

          {esc && (
            <div className="card esc">
              {esc.kind === "raise" && (
                <>
                  <strong>
                    No match &le; ${esc.cap}/hr. Cheapest: {esc.cheapest.id} ${esc.cheapest.price} @ {esc.cheapest.dc}
                  </strong>
                  <p>
                    Raising to <b>${esc.suggested.toFixed(2)}/hr</b> unlocks {esc.unlocks.length}:
                    {esc.unlocks.map((u) => ` ${u.id} $${u.price}`).join(",")}
                  </p>
                  <div className="btn-row">
                    <input
                      type="number"
                      step="0.05"
                      min={esc.cheapest.price}
                      value={escCap}
                      onChange={(e) => setEscCap(e.target.value)}
                    />
                    <button className="btn primary" onClick={() => startScan(Number(escCap))}>
                      Continue with ${Number(escCap).toFixed(2)}/hr
                    </button>
                    <button className="btn" onClick={() => startScan(esc.suggested)}>
                      Launch best now
                    </button>
                    <button className="btn" onClick={() => setScan((s) => ({ ...s, escalation: null }))}>
                      Dismiss
                    </button>
                  </div>
                </>
              )}
              {esc.kind === "none-any" && (
                <>
                  <strong>No &ge;{esc.minVram}GB GPUs available {esc.keepData ? `at ${esc.dc}` : "anywhere"} at any price.</strong>
                  <div className="btn-row">
                    {esc.keepData && (
                      <button
                        className="btn"
                        onClick={() => {
                          setCfg((c) => ({ ...c, keepData: false }));
                          setScan((s) => ({ ...s, escalation: null }));
                        }}
                      >
                        Switch to any-DC (loses data)
                      </button>
                    )}
                    <button className="btn primary" onClick={() => startScan()}>Keep waiting</button>
                    <button className="btn" onClick={() => setScan((s) => ({ ...s, escalation: null }))}>
                      Dismiss
                    </button>
                  </div>
                </>
              )}
              {esc.kind === "flaky" && (
                <>
                  <strong>Cheapest {esc.cheapest.id} ${esc.cheapest.price} now fits the cap - stock flickers.</strong>
                  <div className="btn-row">
                    <button className="btn primary" onClick={() => startScan()}>Try again</button>
                    <button className="btn" onClick={() => setScan((s) => ({ ...s, escalation: null }))}>
                      Dismiss
                    </button>
                  </div>
                </>
              )}
              {esc.kind === "unknown" && <strong>Catalog unavailable - try again.</strong>}
            </div>
          )}

          <pre className="log">{scan.log.join("\n") || "Idle. Press Start scan."}</pre>
        </section>

        <section className="panel">
          <div className="panel-head">
            <h2>Pods</h2>
            <button className="btn" onClick={loadPods} disabled={loadingPods}>
              {loadingPods ? "Loading..." : "Refresh"}
            </button>
          </div>
          {podsErr && <p className="err">{podsErr}</p>}
          {pods.length === 0 && !loadingPods && <p className="muted">No pods.</p>}
          {pods.map((p) => {
            const running = p.desiredStatus === "RUNNING";
            const busy = actBusy.startsWith(p.id);
            return (
              <div className="card" key={p.id}>
                <div className="pod-line">
                  <strong>{p.name || "unnamed"}</strong>
                  <span className={`badge ${running ? "good" : ""}`}>{p.desiredStatus || "?"}</span>
                  <span className="muted">${p.costPerHr}/hr · {p.gpuCount} GPU</span>
                </div>
                <div className="muted mono">{p.id} · {proxyUrl(p.id)}</div>
                <div className="btn-row">
                  {!running && (
                    <button className="btn primary" disabled={busy} onClick={() => podAction(p, "start")}>
                      Start
                    </button>
                  )}
                  {running && (
                    <>
                      <button className="btn" disabled={busy} onClick={() => podAction(p, "stop")}>Stop</button>
                      <button className="btn" disabled={busy} onClick={() => podAction(p, "restart")}>Restart</button>
                      <button className="btn" onClick={() => copyUrl(p.id)}>
                        {copied === p.id ? "Copied!" : "Copy URL"}
                      </button>
                      <a className="btn" href={siteUrl(p.id)} target="_blank" rel="noreferrer">Open app</a>
                      <button className="btn" onClick={() => ping(p.id)}>Health</button>
                      <span className={`badge ${healthMap[p.id] === "ok" ? "good" : ""}`}>
                        {healthMap[p.id] || ""}
                      </span>
                    </>
                  )}
                  {confirmTerm === p.id ? (
                    <button className="btn danger" disabled={busy} onClick={() => podAction(p, "terminate")}>
                      Really delete?
                    </button>
                  ) : (
                    <button className="btn danger" onClick={() => setConfirmTerm(p.id)}>
                      Terminate
                    </button>
                  )}
                </div>
              </div>
            );
          })}
        </section>
      </main>
    </div>
  );
}

export default App;
