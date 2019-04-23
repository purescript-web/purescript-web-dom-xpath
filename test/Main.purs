module Test.Main where

import Prelude

import Data.Array                        ((!!), length)
import Data.Int                          (toNumber)
import Data.Maybe                        (Maybe(..), fromJust, fromMaybe)
import Data.Natural                      (intToNat)
-- import Debug.Trace                       (traceM)
import Effect                            (Effect)
import Effect.Aff                        (Aff)
import Effect.Class                      (liftEffect)
import Effect.Console                    (logShow)
import Foreign                           (isUndefined, isNull, unsafeToForeign)
import Partial.Unsafe                    (unsafePartial)
import Test.Data                         as TD
import Test.Unit                         (suite, test)
import Test.Unit.Main                    (runTest)
import Test.Unit.Assert                  as Assert

import Web.DOM.Document                  (Document, toNode)
import Web.DOM.DOMParser                 (DOMParser, makeDOMParser, parseXMLFromString)
import Web.DOM.Document.XPath            (NSResolver)
import Web.DOM.Document.XPath            as XP
import Web.DOM.Document.XPath.ResultType as RT
import Web.DOM.Element                   (Element, fromNode, getAttribute)
import Web.DOM.Node                      (Node, nodeName)

parseAtomFeedDoc :: DOMParser -> Effect Document
parseAtomFeedDoc dp = parseXMLFromString TD.atomFeedXml dp

parseCatalogDoc :: DOMParser -> Effect Document
parseCatalogDoc dp = parseXMLFromString TD.cdCatalogXml dp

parseNoteDoc :: DOMParser -> Effect Document
parseNoteDoc dp = parseXMLFromString TD.noteXml dp

parseMetajeloDoc :: DOMParser -> Effect Document
parseMetajeloDoc dp = parseXMLFromString TD.metajeloXml dp

atomResolver :: NSResolver
atomResolver = XP.customNSResolver dummyAtomRes
  where dummyAtomRes _ = "http://www.w3.org/2005/Atom"

-- metajeloResolver :: NSResolver
-- metajeloResolver = XP.customNSResolver dummMJRes
--   where dummMJRes _ = "http://ourdomain.cornell.edu/reuse/v.01"

getMetajeloResolver :: Node -> Document -> Effect NSResolver
getMetajeloResolver node doc = do
  nsResolver <- XP.defaultNSResolver node doc
  -- traceM nsResolver
  nodeEleMay :: Maybe Element <- pure $ fromNode node
  defaultNS :: String <- getDefaultNS nodeEleMay
  pure $ XP.customNSResolver $ makeMjNSResFun nsResolver defaultNS
  where
    getDefaultNS :: Maybe Element -> Effect String
    getDefaultNS mayElem = do
      case mayElem of
        Nothing -> pure $ guessedNS
        Just elem -> map nsOrGuess (getAttribute "xmlns" elem)
    guessedNS = "http://ourdomain.cornell.edu/reuse/v.01"
    nsOrGuess :: Maybe String -> String
    nsOrGuess nsMay = fromMaybe guessedNS nsMay
    makeMjNSResFun :: NSResolver -> String -> String -> String
    makeMjNSResFun nsr defNS prefix = case XP.lookupNamespaceURI nsr prefix of
      Nothing -> defNS
      Just ns -> ns

mkCdYear :: Document -> Node -> Aff String
mkCdYear doc node = liftEffect $ XP.evaluateString
  "YEAR"
  node
  Nothing
  Nothing
  doc

main :: Effect Unit
main = runTest do
  suite "non-namespaced tests" do
    test "note.xml and catalog.xml" do
      domParser <- liftEffect $ makeDOMParser

      noteDoc <- liftEffect $ parseNoteDoc domParser
      note <- pure $ toNode noteDoc

      catalogDoc <- liftEffect $ parseCatalogDoc domParser
      catalog <- pure $ toNode catalogDoc

      tlog $ "string type is: "
      tlog RT.string_type
      tlog $ "got a node: " <> (nodeName note)

      noteToRes <- liftEffect $ XP.evaluate
        "/note/to" note Nothing RT.string_type Nothing noteDoc
      noteTo <- liftEffect $ XP.stringValue noteToRes
      tlog $ "got a note to: " <> noteTo
      Assert.equal RT.string_type (XP.resultType noteToRes)
      Assert.equal "Tove" noteTo

      cdPriceRes <- liftEffect $ XP.evaluate
        "/CATALOG/CD[2]/PRICE" catalog Nothing RT.number_type Nothing catalogDoc
      cdPrice <- liftEffect $ XP.numberValue cdPriceRes
      tlog $ "got a cd price: " <> (show cdPrice)
      Assert.equal RT.number_type (XP.resultType cdPriceRes)
      Assert.equal 9.90 cdPrice

      cdYearRes <- liftEffect $ XP.evaluate
        "/CATALOG/CD[2]/YEAR" catalog Nothing RT.number_type Nothing catalogDoc
      cdYear <- liftEffect $ XP.numberValue cdYearRes
      tlog $ "got a cd year: " <> (show cdYear)
      Assert.equal RT.number_type (XP.resultType cdYearRes)
      Assert.equal (toNumber 1988) cdYear

      cdsSnapRes <- liftEffect $ XP.evaluate
        "/CATALOG/CD"
        catalog
        Nothing
        RT.unordered_node_snapshot_type
        Nothing
        catalogDoc
      cdsSnapLen <- liftEffect $ XP.snapshotLength cdsSnapRes
      tlog $ "got " <> (show cdsSnapLen) <> " CDs"
      Assert.equal (intToNat 26) cdsSnapLen
      cdsSnap <- liftEffect $ XP.snapshot cdsSnapRes
      cdYearEval <- pure $ mkCdYear catalogDoc
      Assert.equal 26 (length cdsSnap)
      year0 <- cdYearEval $ unsafePartial $ fromJust $ cdsSnap !! 0
      Assert.equal "1985" year0
      year1 <- cdYearEval $ unsafePartial $ fromJust $ cdsSnap !! 1
      Assert.equal "1988" year1
      year25 <- cdYearEval $ unsafePartial $ fromJust $ cdsSnap !! 25
      Assert.equal "1987" year25

  suite "namespaced tests" do
    test "NS resolver construction" do
      domParser <- liftEffect $ makeDOMParser

      customRes <- pure $ XP.customNSResolver (\x -> "http://foo.com")

      Assert.assertFalse "custom NS resolver shouldn't be undefined"
        (isUndefined $ unsafeToForeign customRes)
      Assert.assertFalse "custom NS resolver shouldn't be null"
        (isNull $ unsafeToForeign customRes)

      atomFeedDoc <-liftEffect $ parseAtomFeedDoc domParser
      atomFeed <- pure $ toNode atomFeedDoc

      createdNSResolver <- pure $ XP.createNSResolver atomFeed atomFeedDoc
      Assert.assertFalse "created NS resolver shouldn't be undefined"
        (isUndefined $ unsafeToForeign createdNSResolver)
      Assert.assertFalse "created NS resolver shouldn't be null"
        (isNull $ unsafeToForeign createdNSResolver)

      defNSResolver <- liftEffect $ XP.defaultNSResolver atomFeed atomFeedDoc
      Assert.assertFalse "default NS resolver shouldn't be undefined"
        (isUndefined $ unsafeToForeign defNSResolver)
      Assert.assertFalse "default NS resolver shouldn't be null"
        (isNull $ unsafeToForeign defNSResolver)

    test "atom.xml" do
      domParser <- liftEffect $ makeDOMParser

      atomFeedDoc <-liftEffect $ parseAtomFeedDoc domParser
      atomFeed <- pure $ toNode atomFeedDoc

      atomEntriesRes <- liftEffect $ XP.evaluate
        "//dummyns:entry"
        atomFeed
        (Just atomResolver)
        RT.unordered_node_snapshot_type
        Nothing
        atomFeedDoc
      atomEntriesLen <- liftEffect $ XP.snapshotLength atomEntriesRes
      tlog $ "got " <> (show atomEntriesLen) <> " atom entries"
      Assert.equal (intToNat 3) atomEntriesLen

    test "metajelo.xml" do
      domParser <- liftEffect $ makeDOMParser

      metajeloDoc <-liftEffect $ parseMetajeloDoc domParser
      metajelo <- pure $ toNode metajeloDoc

      mjNSresolver <- liftEffect $ getMetajeloResolver metajelo metajeloDoc

      metajeloIdRes <- liftEffect $ XP.evaluate
        "/foo:record/foo:identifier"
        metajelo
        (Just mjNSresolver)
        RT.string_type
        Nothing
        metajeloDoc
      metajeloId <- liftEffect $ XP.stringValue metajeloIdRes
      tlog $ "got metajelo id" <> metajeloId
      Assert.equal RT.string_type (XP.resultType metajeloIdRes)
      Assert.equal "OjlTjf" metajeloId

tlog :: forall a. Show a => a -> Aff Unit
tlog = liftEffect <<< logShow
