/* The Tract · "Add to home screen" prompt, shared by the apps.
   One self-contained file: copy it into an app and load it with
   <script src="install.js?v=1" defer data-name="Montage" data-accent="#00d4ff" data-icon="icon-192.png" data-offline="1" data-theme="dark"></script>
   - Chrome, Edge and Samsung on Android/desktop: a real "Install" button (beforeinstallprompt).
   - iPhone and iPad (Safari, and Chrome on iOS 16.4+): two illustrated steps, Share then Add to Home Screen.
   - In-app browsers (Instagram, Facebook, WhatsApp…): asks to open the page in the browser first.
   - Never shown once the app runs from the home screen. "Not now" snoozes it for 7 days.
   window.TractInstall.show() opens it on demand (for an "Install app" button). */
(function () {
  'use strict';
  if (window.TractInstall) return;
  const me = document.currentScript || document.querySelector('script[src*="install.js"]');
  const cfg = (k, d) => (me && me.dataset[k]) || d;
  const NAME = cfg('name', document.title.split(/[·|—-]/)[0].trim());
  const ACC = cfg('accent', '#1F6F68'), ON = cfg('on', '#fff'), DARK = cfg('theme', 'dark') === 'dark', OFF = cfg('offline', '0') === '1';
  const ICON = cfg('icon', (document.querySelector('link[rel="apple-touch-icon"]') || {}).href || '');
  const DELAY = +cfg('delay', 4000), KEY = 'tract_install_' + NAME.toLowerCase().replace(/\W+/g, '');
  const ua = navigator.userAgent, ios = /iPad|iPhone|iPod/.test(ua) || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1);
  const inApp = /FBAN|FBAV|Instagram|Line\/|Snapchat|TikTok|musical_ly|WhatsApp|LinkedInApp|Twitter/i.test(ua);
  const android = /Android/i.test(ua), mobile = ios || android;
  const standalone = () => navigator.standalone || matchMedia('(display-mode: standalone)').matches || matchMedia('(display-mode: fullscreen)').matches;
  const get = () => { try { return JSON.parse(localStorage.getItem(KEY) || '{}'); } catch (e) { return {}; } };
  const set = v => { try { localStorage.setItem(KEY, JSON.stringify(Object.assign(get(), v))); } catch (e) {} };
  const ev = p => { try { window.goatcounter && window.goatcounter.count && window.goatcounter.count({ path: 'install/' + p + '/' + KEY.slice(14), event: true }); } catch (e) {} };
  let deferred = null, el = null;

  addEventListener('beforeinstallprompt', e => { e.preventDefault(); deferred = e; if (!el && eligible()) schedule(800); else if (el) render(); });
  addEventListener('appinstalled', () => { set({ done: 1 }); hide(); ev('installed'); });

  function eligible() { if (standalone()) return false; const s = get(); if (s.done) return false; if (s.snooze && Date.now() < s.snooze) return false; return mobile || !!deferred; }
  let timer = 0; function schedule(ms) { clearTimeout(timer); timer = setTimeout(() => { if (eligible()) show(); }, ms); }

  const I = {
    share: '<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 15V3"/><path d="m7 8 5-5 5 5"/><path d="M5 12v7a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-7"/></svg>',
    plus: '<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="3" width="18" height="18" rx="4"/><path d="M12 8v8M8 12h8"/></svg>',
    dots: '<svg viewBox="0 0 24 24" width="22" height="22" fill="currentColor"><circle cx="12" cy="5" r="2"/><circle cx="12" cy="12" r="2"/><circle cx="12" cy="19" r="2"/></svg>',
    globe: '<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3a14 14 0 0 1 0 18M12 3a14 14 0 0 0 0 18"/></svg>',
    bolt: '<svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M13 2 4 14h7l-1 8 9-12h-7z"/></svg>',
    full: '<svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M4 9V4h5M20 9V4h-5M4 15v5h5M20 15v5h-5"/></svg>',
    wifi: '<svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M2 2l20 20M8.5 16.5a5 5 0 0 1 7 0M5 13a10 10 0 0 1 5.2-2.8M19 13a10 10 0 0 0-2.2-1.6M12 20h.01"/></svg>'
  };
  function css() {
    if (document.getElementById('ti-css')) return;
    const bg = DARK ? 'rgba(17,24,39,.97)' : 'rgba(255,255,255,.98)', fg = DARK ? '#F3F5F8' : '#14212E', mu = DARK ? 'rgba(243,245,248,.68)' : '#55626E', ln = DARK ? 'rgba(255,255,255,.1)' : 'rgba(20,33,46,.1)', chip = DARK ? 'rgba(255,255,255,.07)' : 'rgba(20,33,46,.05)';
    const s = document.createElement('style'); s.id = 'ti-css';
    s.textContent = `
.ti-scrim{position:fixed;inset:0;z-index:2147483000;background:rgba(0,0,0,.38);opacity:0;transition:opacity .25s;-webkit-tap-highlight-color:transparent}
.ti-scrim.on{opacity:1}
.ti{position:fixed;z-index:2147483001;left:50%;bottom:calc(14px + env(safe-area-inset-bottom));width:min(440px,calc(100% - 24px));transform:translate(-50%,130%);transition:transform .38s cubic-bezier(.2,.9,.25,1.1);
  background:${bg};color:${fg};border:1px solid ${ln};border-radius:22px;box-shadow:0 24px 60px rgba(0,0,0,.35),0 0 0 1px ${ACC}22;padding:18px 18px 16px;
  font:15px/1.45 system-ui,-apple-system,"Segoe UI",Roboto,sans-serif;max-height:calc(100% - 28px - env(safe-area-inset-bottom));overflow:auto;overscroll-behavior:contain;-webkit-backdrop-filter:blur(14px);backdrop-filter:blur(14px)}
.ti.on{transform:translate(-50%,0)}
.ti::before{content:"";position:absolute;inset:0;border-radius:inherit;padding:1.5px;background:linear-gradient(135deg,${ACC},transparent 45%,${ACC}88);-webkit-mask:linear-gradient(#000 0 0) content-box,linear-gradient(#000 0 0);-webkit-mask-composite:xor;mask-composite:exclude;pointer-events:none}
.ti-top{display:flex;gap:14px;align-items:center}
.ti-top>div{padding-right:34px}
.ti-icon{width:58px;height:58px;border-radius:15px;flex:0 0 58px;box-shadow:0 8px 22px ${ACC}55;background:${ACC};object-fit:cover;animation:ti-bob 2.6s ease-in-out infinite}
@keyframes ti-bob{0%,100%{transform:translateY(0)}50%{transform:translateY(-3px)}}
.ti-k{font-size:11px;font-weight:800;letter-spacing:.12em;text-transform:uppercase;color:${ACC};filter:${DARK ? 'brightness(1.35)' : 'none'}}
.ti-h{font-size:17.5px;font-weight:800;line-height:1.25;margin:2px 0 0}
.ti-x{position:absolute;top:10px;right:10px;width:34px;height:34px;border:0;border-radius:50%;background:${chip};color:${mu};font-size:20px;line-height:34px;cursor:pointer}
.ti-perks{display:flex;flex-wrap:wrap;gap:6px;margin:14px 0 4px}
.ti-perks span{display:inline-flex;align-items:center;gap:6px;background:${chip};border-radius:99px;padding:5px 10px;font-size:12.5px;color:${mu};font-weight:600}
.ti-perks svg{color:${ACC};filter:${DARK ? 'brightness(1.35)' : 'none'}}
.ti-steps{display:grid;gap:8px;margin:14px 0 2px;padding:0;list-style:none;counter-reset:s}
.ti-steps li{display:flex;align-items:center;gap:12px;background:${chip};border-radius:14px;padding:10px 12px;font-size:14.5px}
.ti-steps li::before{counter-increment:s;content:counter(s);flex:0 0 24px;height:24px;border-radius:50%;background:${ACC};color:${ON};font-weight:800;font-size:13px;display:grid;place-items:center}
.ti-steps .ti-t{flex:1;min-width:0}
.ti-steps .ti-g{flex:0 0 38px;margin-left:auto;display:grid;place-items:center;width:38px;height:38px;border-radius:10px;background:${DARK ? 'rgba(255,255,255,.1)' : '#fff'};color:${DARK ? '#7cc4ff' : '#0A84FF'};box-shadow:0 1px 3px rgba(0,0,0,.12)}
.ti-row{display:flex;gap:10px;margin-top:14px}
.ti-go{flex:1;min-height:48px;border:0;border-radius:14px;background:${ACC};color:${ON};font:inherit;font-weight:800;font-size:16px;cursor:pointer;box-shadow:0 8px 20px ${ACC}55}
.ti-no{min-height:48px;padding:0 16px;border:1px solid ${ln};border-radius:14px;background:transparent;color:${mu};font:inherit;font-weight:700;cursor:pointer}
.ti-arrow{position:fixed;z-index:2147483002;left:50%;bottom:calc(6px + env(safe-area-inset-bottom));transform:translateX(-50%);color:${ACC};animation:ti-pt 1.1s ease-in-out infinite;pointer-events:none}
@keyframes ti-pt{0%,100%{transform:translate(-50%,0)}50%{transform:translate(-50%,6px)}}
@media (orientation:landscape) and (max-height:500px){.ti{width:min(560px,calc(100% - 24px))}.ti-perks{margin-top:10px}.ti-icon{width:46px;height:46px;flex-basis:46px}}
@media (prefers-reduced-motion:reduce){.ti,.ti-scrim{transition:none}.ti-icon,.ti-arrow{animation:none}}`;
    document.head.appendChild(s);
  }
  function perks() {
    return `<div class="ti-perks"><span>${I.bolt}One tap to open</span><span>${I.full}Full screen</span>${OFF ? `<span>${I.wifi}Works offline</span>` : ''}</div>`;
  }
  function body() {
    if (deferred) return `${perks()}<div class="ti-row"><button class="ti-go" data-ti="go">Install ${NAME}</button><button class="ti-no" data-ti="no">Not now</button></div>`;
    if (inApp) return `<ol class="ti-steps"><li><span class="ti-t">Open the menu of this app</span><span class="ti-g">${I.dots}</span></li><li><span class="ti-t">Choose <b>Open in browser</b></span><span class="ti-g">${I.globe}</span></li><li><span class="ti-t">Then add it to your home screen from there</span></li></ol><div class="ti-row"><button class="ti-no" data-ti="no" style="flex:1">Got it</button></div>`;
    if (ios) return `${perks()}<ol class="ti-steps"><li><span class="ti-t">Tap <b>Share</b> in the browser bar</span><span class="ti-g">${I.share}</span></li><li><span class="ti-t">Choose <b>Add to Home Screen</b></span><span class="ti-g">${I.plus}</span></li></ol><div class="ti-row"><button class="ti-no" data-ti="no" style="flex:1">Not now</button></div>`;
    return `${perks()}<ol class="ti-steps"><li><span class="ti-t">Open the browser menu</span><span class="ti-g">${I.dots}</span></li><li><span class="ti-t">Choose <b>Install app</b> or <b>Add to Home screen</b></span><span class="ti-g">${I.plus}</span></li></ol><div class="ti-row"><button class="ti-no" data-ti="no" style="flex:1">Not now</button></div>`;
  }
  function render() {
    if (!el) return;
    el.innerHTML = `<button class="ti-x" data-ti="no" aria-label="Close">×</button>
      <div class="ti-top">${ICON ? `<img class="ti-icon" src="${ICON}" alt="">` : ''}<div><div class="ti-k">Free app · no store needed</div><div class="ti-h" id="ti-h">Put ${NAME} on your home screen</div></div></div>${body()}`;
  }
  function show() {
    if (el || standalone()) return; css();
    const sc = document.createElement('div'); sc.className = 'ti-scrim'; sc.dataset.ti = 'no';
    el = document.createElement('div'); el.className = 'ti'; el.setAttribute('role', 'dialog'); el.setAttribute('aria-labelledby', 'ti-h');
    render(); document.body.appendChild(sc); document.body.appendChild(el);
    let arrow = null;
    if (ios && !deferred && !inApp && !/iPad/.test(ua)) { arrow = document.createElement('div'); arrow.className = 'ti-arrow'; arrow.innerHTML = '<svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round"><path d="M12 4v15M6 13l6 6 6-6"/></svg>'; }
    if (arrow) { document.body.appendChild(arrow); el.style.bottom = 'calc(46px + env(safe-area-inset-bottom))'; }
    requestAnimationFrame(() => { sc.classList.add('on'); el.classList.add('on'); });
    const off = e => { const t = e.target.closest('[data-ti]'); if (!t) return;
      if (t.dataset.ti === 'go' && deferred) { deferred.prompt(); ev('prompt'); deferred.userChoice.then(r => { if (r.outcome === 'accepted') { set({ done: 1 }); ev('accepted'); } else set({ snooze: Date.now() + 7 * 864e5 }); deferred = null; hide(); }); }
      else { set({ snooze: Date.now() + 7 * 864e5 }); ev('later'); hide(); } };
    sc.addEventListener('click', off); el.addEventListener('click', off);
    el._sc = sc; el._ar = arrow; ev('shown');
    addEventListener('keydown', function esc(e) { if (e.key === 'Escape') { hide(); removeEventListener('keydown', esc); } });
  }
  function hide() {
    if (!el) return; const e = el, sc = e._sc; el = null; e.classList.remove('on'); sc && sc.classList.remove('on'); e._ar && e._ar.remove();
    setTimeout(() => { e.remove(); sc && sc.remove(); }, 400);
  }
  window.TractInstall = { show: () => { if (standalone()) return; show(); }, available: () => !standalone() };
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', () => schedule(DELAY)); else schedule(DELAY);
})();
