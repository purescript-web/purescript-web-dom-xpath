module Web.DOM.Document.XPath where

import Prelude

import Data.Int                               (round, toNumber)
import Data.Maybe                             (Maybe(..))
import Data.Nullable                          (Nullable, toMaybe, toNullable)
import Data.Natural                           (Natural, intToNat, natToInt)
import Effect                                 (Effect)
import Web.DOM.Document                       (Document, documentElement, fromNode)
import Web.DOM.Element                        (toNode)
import Web.DOM.Node                           (Node, ownerDocument)
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
  -> Effect XPathResult
evaluate xpath ctxt nsres resType res doc =
  evaluateInternal xpath ctxt (toNullable nsres) resType (toNullable res) doc

foreign import evaluateInternal ::
  String
  -> Node
  -> Nullable NSResolver
  -> ResultType
  -> Nullable XPathResult
  -> Document
  -> Effect XPathResult

-- createExpression :: TODO


             --- XPathResult functions ---

foreign import resultType :: XPathResult -> ResultType

foreign import numberValue :: XPathResult -> Effect Number

foreign import stringValue :: XPathResult -> Effect String

foreign import booleanValue :: XPathResult -> Effect Boolean

foreign import singleNodeValueInternal :: XPathResult -> Effect (Nullable Node)
singleNodeValue :: XPathResult -> Effect (Maybe Node)
singleNodeValue = map toMaybe <<< singleNodeValueInternal

foreign import invalidIteratorState :: XPathResult -> Boolean

foreign import snapshotLengthInternal :: XPathResult -> Effect Number
snapshotLength :: XPathResult -> Effect Natural
snapshotLength = map (intToNat <<< round) <<< snapshotLengthInternal

foreign import iterateNextInternal :: XPathResult -> Effect (Nullable Node)
iterateNext :: XPathResult -> Effect (Maybe Node)
iterateNext = map toMaybe <<< iterateNextInternal

foreign import snapshotItemInternal ::
  XPathResult -> Number -> Effect (Nullable Node)
snapshotItem :: XPathResult -> Natural -> Effect (Maybe Node)
snapshotItem xpres ix = map toMaybe $
  snapshotItemInternal xpres (toNumber $ natToInt $ ix)

  --- namespace resolver functions ---

foreign import customNSResolver :: (String -> String) -> NSResolver

foreign import createNSResolver :: Node -> Document -> NSResolver

-- | Same interface as `createNSResolver`, but will use the owner
-- document as the nodeResolver if it exists. See [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Introduction_to_using_XPath_in_JavaScript#Implementing_a_Default_Namespace_Resolver).
defaultNSResolver :: Node -> Document -> Effect NSResolver
defaultNSResolver nodeRes doc = do
  ownerDoc <- ownerDocument nodeRes
  nodeResFinal <- case ownerDoc of
    Nothing -> case (fromNode nodeRes) of
      Nothing -> pure nodeRes
      Just nodeResEl ->  documentElement (toNode nodeResEl)
    Just od -> documentElement od
  createNSResolver nodeResFinal doc
