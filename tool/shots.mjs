// CI preview screenshots of key routes (phone + desktop).
import { chromium } from 'playwright-core';
import fs from 'node:fs';
const base = 'http://127.0.0.1:8080';
const routes = [
  ['home', '/'],
  ['assess', '/assess'],
  ['localization', '/localization/temporal'],
  ['ex-seizure', '/example/convulsive-seizure'],
  ['ex-syncope', '/example/convulsive-syncope'],
  ['ex-cardiac', '/example/cardiac-red-flag'],
  ['ex-pnes', '/example/pnes'],
  ['atlas', '/atlas'],
  ['atlas-jme', '/atlas/juvenile-myoclonic-epilepsy/'],
  ['about', '/about'],
];
fs.mkdirSync('shots', { recursive: true });
const log = [];
const browser = await chromium.launch({ executablePath: '/usr/bin/google-chrome' });
for (const [dev, vp] of [['phone', { width: 390, height: 844 }], ['desk', { width: 1366, height: 900 }]]) {
  const ctx = await browser.newContext({ viewport: vp, deviceScaleFactor: dev === 'phone' ? 2 : 1 });
  const page = await ctx.newPage();
  page.on('pageerror', (e) => log.push(`${dev} pageerror ${e.message}`));
  for (const [name, path] of routes) {
    const t0 = Date.now();
    await page.goto(base + path, { waitUntil: 'networkidle' });
    await page.waitForSelector('flt-glass-pane, flutter-view', { timeout: 30000 }).catch(() => {});
    await page.waitForTimeout(3500);
    log.push(`${dev} ${name} ${Date.now() - t0}ms url=${page.url()}`);
    await page.screenshot({ path: `shots/${dev}-${name}.png` });
    if (name.startsWith('ex-')) {
      await page.mouse.move(vp.width / 2, vp.height / 2);
      for (let k = 1; k <= 5; k++) {
        for (let j = 0; j < 6; j++) { await page.mouse.wheel(0, vp.height * 0.15); await page.waitForTimeout(80); }
        await page.waitForTimeout(900);
        await page.screenshot({ path: `shots/${dev}-${name}-${k}.png` });
      }
    }
  }
  await ctx.close();
}
await browser.close();
fs.writeFileSync('shots/log.txt', log.join('\n') + '\n');
console.log(log.join('\n'));
