export function evaluateInternal(xpathExpression) {
  return function (contextNode) {
    return function (namespaceResolver) {
      return function (resultType) {
        return function (result) {
          return function (doc) {
            return function () { // Effect thunk
              return doc.evaluate(
                xpathExpression
                , contextNode
                , namespaceResolver
                , resultType
                , result
              );
            };
          };
        };
      };
    };
  };
}

//       --- XPathResult functions ---

export function resultType(xpathResult) {
  return xpathResult.resultType;
}

export function numberValue(xpathResult) {
  return function () { // Effect thunk
    return xpathResult.numberValue;
  };
}

export function stringValue(xpathResult) {
  return function () { // Effect thunk
    return xpathResult.stringValue;
  };
}

export function booleanValue(xpathResult) {
  return function () { // Effect thunk
    return xpathResult.booleanValue;
  };
}

export function singleNodeValueInternal(xpathResult) {
  return function () { // Effect thunk
    return xpathResult.singleNodeValue;
  };
}

export function invalidIteratorState(xpathResult) {
  return xpathResult.invalidIteratorState;
}

export function snapshotLengthInternal(xpathResult) {
  return function () { // Effect thunk
    return xpathResult.snapshotLength;
  };
}

export function iterateNextInternal(xpathResult) {
  return function () { // Effect thunk
    return xpathResult.iterateNext();
  };
}

export function snapshotItemInternal(xpathResult) {
  return function (index) {
    return function () { // Effect thunk
      return xpathResult.snapshotItem(index);
    };
  };
}

//       --- namespace resolver functions ---

export function customNSResolver(customRes) {
  var nsResolver = {
    lookupNamespaceURI : customRes
  };
  return nsResolver;
}

export function createNSResolver(nodeResolver) {
  return function (doc) {
    return doc.createNSResolver(nodeResolver);
  };
}

export function lookupNamespaceURIInternal(nsResolver) {
  return function (prefix) {
    return nsResolver.lookupNamespaceURI(prefix);
  };
}

// exports._makeEmptyDoc = function () {  // Effect thunk
//     var doc = (new DOMParser()).parseFromString('<dummy/>', 'application/xml');
//     doc.removeChild(doc.documentElement);
//     return doc;
// };

