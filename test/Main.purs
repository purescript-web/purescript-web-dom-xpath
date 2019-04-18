module Test.Main where

import Prelude

import Data.Int                          (toNumber)
import Data.Maybe                        (Maybe(..))
import Data.Natural                      (intToNat)
import Debug.Trace                       (traceM)
import Effect                            (Effect)
import Effect.Aff                        (Aff)
import Effect.Class                      (liftEffect)
import Effect.Console                    (logShow)

import Test.Data                         as TD
import Test.Unit                         (suite, test)
import Test.Unit.Main                    (runTest)
import Test.Unit.Assert                  as Assert

import Web.DOM.Document                  (Document, toNode)
import Web.DOM.DOMParser                 (DOMParser, makeDOMParser, parseXMLFromString)
import Web.DOM.Document.XPath            (NSResolver)
import Web.DOM.Document.XPath            as XP
import Web.DOM.Document.XPath.ResultType as RT
import Web.DOM.Node                      (nodeName)

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

metajeloResolver :: NSResolver
metajeloResolver = XP.customNSResolver dummMJRes
  where dummMJRes _ = "http://ourdomain.cornell.edu/reuse/v.01"

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

  suite "namespaced tests" do
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

      metajeloIdRes <- liftEffect $ XP.evaluate
        "/record/identifier"
        metajelo
        (Just metajeloResolver)
        RT.string_type
        Nothing
        metajeloDoc
      traceM metajeloIdRes -- DEBUG
      metajeloId <- liftEffect $ XP.stringValue metajeloIdRes
      tlog $ "got metajelo id" <> metajeloId
      Assert.equal RT.string_type (XP.resultType metajeloIdRes)
      Assert.equal "OjlTjf" metajeloId

tlog :: forall a. Show a => a -> Aff Unit
tlog = liftEffect <<< logShow
