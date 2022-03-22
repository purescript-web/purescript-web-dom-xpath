import {JSDOM} from "jsdom";
const { XPathResult, DOMParser } = new JSDOM().window;

Object.assign(global, { XPathResult, DOMParser })

require("../output/Test.Main/index.js").main({ browser: false })();
