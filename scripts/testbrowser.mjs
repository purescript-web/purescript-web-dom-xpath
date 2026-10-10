import { chromium } from "playwright";

const browser = await chromium.launch();
try {
  const page = await browser.newPage();
  const completed = new Promise((resolve, reject) => {
    page.on("pageerror", reject);
    page.on("console", (message) => {
      console.log(message.text());
      if (message.text() === "All tests passed") resolve();
    });
    page.setDefaultTimeout(30000);
    page
      .waitForEvent("console", {
        predicate: (message) => message.text() === "All tests passed",
      })
      .catch(reject);
  });
  await Promise.all([completed, page.goto(new URL("../test/index.html", import.meta.url).href)]);
  console.log(`Chromium ${browser.version()}: browser assertions passed`);
} finally {
  await browser.close();
}
