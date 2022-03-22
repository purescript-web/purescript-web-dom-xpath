import {JSDOM} from "jsdom";
const { XPathResult, DOMParser } = new JSDOM().window;

Object.assign(global, { XPathResult, DOMParser });

(async () => {
  const { main } = await import("../output/Test.Main/index.js");
  main({ browser: false })();
})();
