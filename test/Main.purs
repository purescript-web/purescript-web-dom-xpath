module Test.Main where

import Prelude

import Control.Monad.Reader.Class        (class MonadReader, ask, local)
import Control.Monad.Reader.Trans        (runReaderT)
import Data.Array                        ((!!), length)
import Data.Either                       (Either, fromRight')
import Data.Int                          (toNumber)
import Data.Maybe                        (Maybe(..), fromJust, fromMaybe)
import Effect                            (Effect)
import Effect.Aff                        (launchAff_)
import Effect.Class                      (class MonadEffect, liftEffect)
import Effect.Console                    (logShow, log)
import Foreign                           (isUndefined, isNull, unsafeToForeign)
import Partial.Unsafe                    (unsafePartial, unsafeCrashWith)
import Test.Assert                       as Assert
import Test.Data                         as TD

import Web.DOM.Document                  (Document, toNode)
import Web.DOM.Document.XPath            (NSResolver)
import Web.DOM.Document.XPath            as XP
import Web.DOM.Document.XPath.ResultType as RT
import Web.DOM.DOMParser                 (DOMParser, makeDOMParser, parseXMLFromString)
import Web.DOM.Element                   (Element, fromNode, getAttribute)
import Web.DOM.Node                      (Node, nodeName)

unsafeFromRight :: forall l r. Either l r -> r
unsafeFromRight = fromRight' (\_ -> unsafeCrashWith "Value was not Right")

parseAtomFeedDoc :: DOMParser -> Effect Document
parseAtomFeedDoc dp = map unsafeFromRight $
  parseXMLFromString TD.atomFeedXml dp

parseCatalogDoc :: DOMParser -> Effect Document
parseCatalogDoc dp = map unsafeFromRight $
  parseXMLFromString TD.cdCatalogXml dp

parseNoteDoc :: DOMParser -> Effect Document
parseNoteDoc dp = map unsafeFromRight $
  parseXMLFromString TD.noteXml dp

parseMetajeloDoc :: DOMParser -> Effect Document
parseMetajeloDoc dp = map unsafeFromRight $
  parseXMLFromString TD.metajeloXml dp

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

mkCdYear :: forall m. MonadEffect m => Document -> Node -> m String
mkCdYear doc node = liftEffect $ XP.evaluateString
  "YEAR"
  node
  Nothing
  Nothing
  doc

-----------------------------------------------------------------

-- Provide similar API to purescript-spec to reduce code changes

suite :: forall m. MonadReader String m => MonadEffect m => String -> m Unit -> m Unit
suite msg runTest = do
  previous <- ask
  let testName = previous <> msg
  liftEffect $ log testName
  local (_ <> " ") runTest

test :: forall m. MonadReader String m => MonadEffect m => String -> m Unit -> m Unit
test = suite

-- Replaces `test-unit`'s `Test.Unit.Assert.equal`, which has its first
-- arg be the expected value and the second arg be the actual value.
-- See `Test.Unit.Assert.shouldEqual` for proof.
shouldEqual :: forall m a. MonadEffect m => Eq a => Show a => a -> a -> m Unit
shouldEqual expected actual =
  liftEffect $ Assert.assertEqual { actual, expected }

assertFalse :: forall m. MonadEffect m => String -> Boolean -> m Unit
assertFalse msg val =
  liftEffect $ Assert.assertFalse' msg val

-----------------------------------------------------------------

main :: { browser :: Boolean } -> Effect Unit
main { browser } = launchAff_ $ flip runReaderT "" do
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
      shouldEqual RT.string_type (XP.resultType noteToRes)
      shouldEqual "Tove" noteTo

      cdPriceRes <- liftEffect $ XP.evaluate
        "/CATALOG/CD[2]/PRICE" catalog Nothing RT.number_type Nothing catalogDoc
      cdPrice <- liftEffect $ XP.numberValue cdPriceRes
      tlog $ "got a cd price: " <> (show cdPrice)
      shouldEqual RT.number_type (XP.resultType cdPriceRes)
      shouldEqual 9.90 cdPrice

      cdYearRes <- liftEffect $ XP.evaluate
        "/CATALOG/CD[2]/YEAR" catalog Nothing RT.number_type Nothing catalogDoc
      cdYear <- liftEffect $ XP.numberValue cdYearRes
      tlog $ "got a cd year: " <> (show cdYear)
      shouldEqual RT.number_type (XP.resultType cdYearRes)
      shouldEqual (toNumber 1988) cdYear

      cdsSnapRes <- liftEffect $ XP.evaluate
        "/CATALOG/CD"
        catalog
        Nothing
        RT.unordered_node_snapshot_type
        Nothing
        catalogDoc
      cdsSnapLen <- liftEffect $ XP.snapshotLength cdsSnapRes
      tlog $ "got " <> (show cdsSnapLen) <> " CDs"
      shouldEqual 26 cdsSnapLen
      cdsSnap <- liftEffect $ XP.snapshot cdsSnapRes
      cdYearEval <- pure $ mkCdYear catalogDoc
      shouldEqual 26 (length cdsSnap)
      year0 <- cdYearEval $ unsafePartial $ fromJust $ cdsSnap !! 0
      shouldEqual "1985" year0
      year1 <- cdYearEval $ unsafePartial $ fromJust $ cdsSnap !! 1
      shouldEqual "1988" year1
      year25 <- cdYearEval $ unsafePartial $ fromJust $ cdsSnap !! 25
      shouldEqual "1987" year25

  suite "namespaced tests" do
    test "NS resolver construction" do
      domParser <- liftEffect $ makeDOMParser

      customRes <- pure $ XP.customNSResolver (\_ -> "http://foo.com")

      assertFalse "custom NS resolver shouldn't be undefined"
        (isUndefined $ unsafeToForeign customRes)
      assertFalse "custom NS resolver shouldn't be null"
        (isNull $ unsafeToForeign customRes)

      when browser $ do
        atomFeedDoc <- liftEffect $ parseAtomFeedDoc domParser
        atomFeed <- pure $ toNode atomFeedDoc

        createdNSResolver <- pure $ XP.createNSResolver atomFeed atomFeedDoc
        assertFalse "created NS resolver shouldn't be undefined"
          (isUndefined $ unsafeToForeign createdNSResolver)
        assertFalse "created NS resolver shouldn't be null"
          (isNull $ unsafeToForeign createdNSResolver)

        defNSResolver <- liftEffect $ XP.defaultNSResolver atomFeed atomFeedDoc
        assertFalse "default NS resolver shouldn't be undefined"
          (isUndefined $ unsafeToForeign defNSResolver)
        assertFalse "default NS resolver shouldn't be null"
          (isNull $ unsafeToForeign defNSResolver)

    test "atom.xml" $ when browser do
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
      shouldEqual 3 atomEntriesLen

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
      shouldEqual RT.string_type (XP.resultType metajeloIdRes)
      when browser $ shouldEqual "OjlTjf" metajeloId

      prod0pol0xpath <- pure $
        "/x:record/x:supplementaryProducts/x:supplementaryProduct[1]" <>
        "/x:location/x:institutionPolicies/x:institutionPolicy[1]"

      mjProd0Pol0Res <- liftEffect $ XP.evaluate
        (prod0pol0xpath <>  "/x:refPolicy")
        metajelo
        (Just mjNSresolver)
        RT.string_type
        Nothing
        metajeloDoc
      mjProd0Pol0 <- liftEffect $ XP.stringValue mjProd0Pol0Res
      tlog $ "got metajelo ref policy " <> mjProd0Pol0
      shouldEqual RT.string_type (XP.resultType mjProd0Pol0Res)
      when browser $ shouldEqual "http://skGHargw/" mjProd0Pol0
      --
      mjProd0Pol0AppliesRes <- liftEffect $ XP.evaluate
        (prod0pol0xpath <>  "/@appliesToProduct")
        metajelo
        (Just mjNSresolver)
        RT.string_type
        Nothing
        metajeloDoc
      mjProd0Pol0Applies <- liftEffect $ XP.stringValue mjProd0Pol0AppliesRes
      tlog $ "got metajelo policy appliesToProduct: " <> (show mjProd0Pol0Applies)
      shouldEqual RT.string_type (XP.resultType mjProd0Pol0AppliesRes)
      when browser $ shouldEqual "0" mjProd0Pol0Applies

tlog :: forall a m. MonadEffect m => Show a => a -> m Unit
tlog = liftEffect <<< logShow
