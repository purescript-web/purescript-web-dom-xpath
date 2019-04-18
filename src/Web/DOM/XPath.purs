module Web.DOM.Document.XPath where

import Prelude

import Data.Int                               (round, toNumber)
import Data.Maybe                             (Maybe{-(..)-})
import Data.Nullable                          (Nullable, toMaybe, toNullable)
import Data.Natural                           (Natural, intToNat, natToInt)
import Web.DOM.Document                       (Document{-, documentElement-})
import Web.DOM.Node                           (Node{-, ownerDocument-})
import Web.DOM.Document.XPath.ResultType      (ResultType)

foreign import data XPathEvaluator :: Type
foreign import data NSResolver :: Type
foreign import data XPathResult :: Type

evaluate ::
  String
  -> Node
  -> Maybe NSResolver
  -> ResultType
  -> Maybe XPathResult
  -> Document
  -> XPathResult
evaluate xpath ctxt nsres resType res doc =
  evaluateInternal xpath ctxt (toNullable nsres) resType (toNullable res) doc

foreign import evaluateInternal ::
  String
  -> Node
  -> Nullable NSResolver
  -> ResultType
  -> Nullable XPathResult
  -> Document
  -> XPathResult

-- createExpression :: TODO


             --- XPathResult functions ---

foreign import resultType :: XPathResult -> ResultType

foreign import numberValue :: XPathResult -> Number

foreign import stringValue :: XPathResult -> String

foreign import booleanValue :: XPathResult -> Boolean

foreign import singleNodeValueInternal :: XPathResult -> Nullable Node
singleNodeValue :: XPathResult -> Maybe Node
singleNodeValue = toMaybe <<< singleNodeValueInternal

foreign import invalidIteratorState :: XPathResult -> Boolean

foreign import snapshotLengthInternal :: XPathResult -> Number
snapshotLength :: XPathResult -> Natural
snapshotLength = intToNat <<< round <<< snapshotLengthInternal

foreign import iterateNextInternal :: XPathResult -> Nullable Node
iterateNext :: XPathResult -> Maybe Node
iterateNext = toMaybe <<< iterateNextInternal

foreign import snapshotItemInternal :: XPathResult -> Number -> Nullable Node
snapshotItem :: XPathResult -> Natural -> Maybe Node
snapshotItem xpres ix = toMaybe $
  snapshotItemInternal xpres (toNumber $ natToInt $ ix)

  --- namespace resolver functions ---

foreign import customNSResolver :: (String -> String) -> NSResolver

foreign import createNSResolver :: Node -> Document -> NSResolver

-- | Same interface as `createNSResolver`, but will use the owner
-- document as the nodeResolver if it exists. See [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Introduction_to_using_XPath_in_JavaScript#Implementing_a_Default_Namespace_Resolver).
-- TODO: need to add Effect handling here:
-- defaultNSResolver :: Node -> Document -> NSResolver
-- defaultNSResolver nodeRes doc = case ownerDocument nodeRes of
--   Nothing -> documentElement nodeRes
--   Just ownerDoc -> documentElement ownerDoc
