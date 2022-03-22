import {JSDOM} from "jsdom";
import { main } from "../output/Test.Main/index.js";
const { XPathResult, DOMParser } = new JSDOM().window;

Object.assign(global, { XPathResult, DOMParser });

main({ browser: false })();
