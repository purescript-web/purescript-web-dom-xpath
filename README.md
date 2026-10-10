# purescript-web-xpath

[![Latest release](http://img.shields.io/github/release/purescript-web/purescript-web-dom-xpath.svg)](https://github.com/purescript-web/purescript-web-dom-xpath/releases)
[![Build status](https://github.com/purescript-web/purescript-web-dom-xpath/workflows/CI/badge.svg?branch=master)](https://github.com/purescript-web/purescript-web-dom-xpath/actions?query=workflow%3ACI+branch%3Amaster)
[![Pursuit](https://pursuit.purescript.org/packages/purescript-web-dom-xpath/badge)](https://pursuit.purescript.org/packages/purescript-web-dom-xpath)

Type definitions and low level interface implementations for the [W3C DOM XPath API](https://www.w3.org/TR/DOM-Level-3-XPath/).

## Installation

```
spago install web-dom-xpath
```

## Documentation

Module documentation is [published on Pursuit](http://pursuit.purescript.org/packages/purescript-web-dom-xpath).

## Tests

### Run tests in a browser

Run `npm ci`, `npx playwright install chromium`, and `npm run testbrowser` to run
the tests in Chromium. To inspect them interactively, open `test/index.html`
with your browser's web console open after building the bundle.

### Headless testing

Run `npm test` to run the jsdom tests. Namespace assertions requiring browser
support run in the Chromium suite.
