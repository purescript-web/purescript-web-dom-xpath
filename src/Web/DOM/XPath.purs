module Web.DOM.Document.XPath where

import Prelude

import Data.Array                             (catMaybes, range)
import Data.Int                               (round, toNumber)
import Data.Maybe                             (Maybe(..))
import Data.Nullable                          (Nullable, toMaybe, toNullable)
import Data.Natural                           (Natural, intToNat, natToInt)
import Data.Traversable                       (sequence)
import Effect                                 (Effect)
import Web.DOM.Document                       (Document, documentElement)
import Web.DOM.Document                       as Doc
import Web.DOM.Element                        as Elem
import Web.DOM.Node                           (Node, ownerDocument)
import Web.DOM.Document.XPath.ResultType      (ResultType)
import Web.DOM.Document.XPath.ResultType      as RT

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

-- | Convenience function to avoid two funciton calls and possibly mismatched types.
evaluateNumber ::
  String
  -> Node
  -> Maybe NSResolver
  -> Maybe XPathResult
  -> Document
  -> Effect Number
evaluateNumber xpath ctxt nsres res doc = do
  xr <- evaluateInternal xpath ctxt (toNullable nsres) RT.number_type (toNullable res) doc
  numberValue xr

-- | Convenience function to avoid two funciton calls and possibly mismatched types.
evaluateString ::
  String
  -> Node
  -> Maybe NSResolver
  -> Maybe XPathResult
  -> Document
  -> Effect String
evaluateString xpath ctxt nsres res doc = do
  xr <- evaluateInternal xpath ctxt (toNullable nsres) RT.string_type (toNullable res) doc
  stringValue xr

-- | Convenience function to avoid two funciton calls and possibly mismatched types.
evaluateBoolean ::
  String
  -> Node
  -> Maybe NSResolver
  -> Maybe XPathResult
  -> Document
  -> Effect Boolean
evaluateBoolean xpath ctxt nsres res doc = do
  xr <- evaluateInternal xpath ctxt (toNullable nsres) RT.boolean_type (toNullable res) doc
  booleanValue xr

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

-- | High level wrapper around [snapshotItem](#v:snapshotItem)
-- | and [snapshotLength](#v:snapshotLength)
-- | that directly returns an `Array` of `Node`s.
snapshot :: XPathResult -> Effect (Array Node)
snapshot xpres = case snapMay of
  Nothing -> pure mempty
  Just eArray -> eArray
  where
    snapTypMay = RT.res2SnapType $ resultType xpres
    snapMay = map snapshotInternal snapTypMay
    nodeAtIdx :: Natural -> Effect (Maybe Node)
    nodeAtIdx = snapshotItem xpres
    snapshotInternal :: RT.SnapshotType ->  Effect (Array Node)
    snapshotInternal snapType = do
      nNodes <- snapshotLength xpres
      nNodesInt <- pure $ natToInt nNodes
      -- nodeArray <- pure $ replicate nNodesInt _emptyNode
      indices <- pure $ map intToNat $ range 0 (nNodesInt - 1)
      nodeArray <- sequence $ map nodeAtIdx indices
      -- TODO: currently this is likely slow due to not using state
      pure $ catMaybes nodeArray

-- -- | Unsafely provided for performance in e.g. allocation of `Array`s.
-- _emptyDoc :: Document
-- _emptyDoc = unsafePerformEffect _makeEmptyDoc

-- foreign import _makeEmptyDoc :: Effect Document

-- -- | Unsafely provided for performance in e.g. allocation of `Array`s.
-- _emptyNode :: Node
-- _emptyNode = toNode _emptyDoc

  --- namespace resolver functions ---

foreign import customNSResolver :: (String -> String) -> NSResolver

foreign import createNSResolver :: Node -> Document -> NSResolver

foreign import lookupNamespaceURIInternal :: NSResolver -> String -> Nullable String
lookupNamespaceURI :: NSResolver -> String -> Maybe String
lookupNamespaceURI nsRes prefix = toMaybe $ lookupNamespaceURIInternal nsRes prefix

-- | Same interface as `createNSResolver`, but will use the owner
-- | document as the nodeResolver if it exists. See [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Introduction_to_using_XPath_in_JavaScript#Implementing_a_Default_Namespace_Resolver).
defaultNSResolver :: Node -> Document -> Effect NSResolver
defaultNSResolver nodeRes doc = do
  ownerDoc <- ownerDocument nodeRes
  nodeResFinal <- case ownerDoc of
    Nothing -> case (Doc.fromNode nodeRes) of
      Nothing -> pure nodeRes
      Just nodeRelAsDoc -> docElemOrDefault nodeRelAsDoc
    Just od -> docElemOrDefault od
  pure $ createNSResolver nodeResFinal doc
  where
    docElemOrDefault :: Document -> Effect Node
    docElemOrDefault dc = do
      docElMay <- documentElement dc
      pure $ case docElMay of
        Nothing -> nodeRes
        Just docEl -> Elem.toNode docEl
