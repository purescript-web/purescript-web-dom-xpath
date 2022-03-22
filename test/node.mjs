import {JSDOM} from "jsdom";
import Main from "../output/Test.Main/index.js";
const { XPathResult, DOMParser } = new JSDOM().window;

Object.assign(global, { XPathResult, DOMParser });

Main.main({ browser: false })();
