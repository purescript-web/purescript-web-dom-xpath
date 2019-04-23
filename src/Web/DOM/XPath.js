"use strict";

exports.evaluateInternal = function (xpathExpression) {
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
};


//       --- XPathResult functions ---

exports.resultType = function (xpathResult) {
  return xpathResult.resultType;
};

exports.numberValue = function (xpathResult) {
  return function () { // Effect thunk
    return xpathResult.numberValue;
  };
};

exports.stringValue = function (xpathResult) {
  return function () { // Effect thunk
    return xpathResult.stringValue;
  };
};

exports.booleanValue = function (xpathResult) {
  return function () { // Effect thunk
    return xpathResult.booleanValue;
  };
};

exports.singleNodeValueInternal = function (xpathResult) {
  return function () { // Effect thunk
    return xpathResult.singleNodeValue;
  };
};

exports.invalidIteratorState = function (xpathResult) {
  return xpathResult.invalidIteratorState;
};

exports.snapshotLengthInternal = function (xpathResult) {
  return function () { // Effect thunk
    return xpathResult.snapshotLength;
  };
};

exports.iterateNextInternal = function (xpathResult) {
  return function () { // Effect thunk
    return xpathResult.iterateNext();
  };
};

exports.snapshotItemInternal = function (xpathResult) {
  return function (index) {
    return function () { // Effect thunk
      return xpathResult.snapshotItem(index);
    };
  };
};

//       --- namespace resolver functions ---

exports.customNSResolver = function (customRes) {
  var nsResolver = {
    lookupNamespaceURI : customRes
  };
  return nsResolver;
};

exports.createNSResolver = function (nodeResolver) {
  return function (doc) {
    return doc.createNSResolver(nodeResolver);
  };
};

exports.lookupNamespaceURIInternal = function (nsResolver) {
  return function (prefix) {
    return nsResolver.lookupNamespaceURI(prefix);
  };
};

// exports._makeEmptyDoc = function () {  // Effect thunk
//     var doc = (new DOMParser()).parseFromString('<dummy/>', 'application/xml');
//     doc.removeChild(doc.documentElement);
//     return doc;
// };

