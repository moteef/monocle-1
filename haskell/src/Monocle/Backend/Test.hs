{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- |
module Monocle.Backend.Test where

import Control.Exception (bracket)
import Control.Monad.Random.Lazy
import qualified Data.Text as Text
import Data.Time.Clock (addUTCTime, secondsToNominalDiffTime)
import Data.Time.Format (defaultTimeLocale, formatTime)
import qualified Database.Bloodhound as BH
import qualified Monocle.Api.Config as Config
import Monocle.Backend.Documents
import qualified Monocle.Backend.Index as I
import qualified Monocle.Backend.Queries as Q
import qualified Monocle.Crawler as CrawlerPB
import Monocle.Prelude
import qualified Monocle.Search.Query as Q
import Monocle.Servant.Env
import Relude.Unsafe ((!!))
import Test.Tasty.HUnit

fakeDate :: UTCTime
fakeDate = fromMaybe (error "nop") (readMaybe "2021-05-31 10:00:00 Z")

fakeDateAlt :: UTCTime
fakeDateAlt = fromMaybe (error "nop") (readMaybe "2021-06-01 20:00:00 Z")

fakeAuthor :: Author
fakeAuthor = Author "John" "John"

mkFakeChange :: Int -> LText -> ELKChange
mkFakeChange number title =
  fakeChange
    { elkchangeId = "aFakeId-" <> show number,
      elkchangeNumber = number,
      elkchangeTitle = title,
      elkchangeUrl = "https://fakehost/change/" <> show number
    }

fakeChange :: ELKChange
fakeChange =
  ELKChange
    { elkchangeId = "",
      elkchangeType = "Change",
      elkchangeNumber = 1,
      elkchangeChangeId = "change-id",
      elkchangeTitle = "",
      elkchangeUrl = "",
      elkchangeCommitCount = 1,
      elkchangeAdditions = 1,
      elkchangeDeletions = 1,
      elkchangeChangedFilesCount = 1,
      elkchangeChangedFiles = [File 0 0 "/fake/path"],
      elkchangeText = "",
      elkchangeCommits = [],
      elkchangeRepositoryPrefix = "",
      elkchangeRepositoryFullname = "",
      elkchangeRepositoryShortname = "",
      elkchangeAuthor = fakeAuthor,
      elkchangeBranch = "",
      elkchangeCreatedAt = fakeDate,
      elkchangeUpdatedAt = fakeDate,
      elkchangeMergedBy = Nothing,
      elkchangeTargetBranch = "main",
      elkchangeMergedAt = Nothing,
      elkchangeClosedAt = Nothing,
      elkchangeDuration = Nothing,
      elkchangeApproval = Just ["OK"],
      elkchangeSelfMerged = Nothing,
      elkchangeTasksData = Nothing,
      elkchangeState = "OPEN",
      elkchangeMergeable = "",
      elkchangeLabels = [],
      elkchangeAssignees = [],
      elkchangeDraft = False
    }

emptyConfig :: Text -> Config.Index
emptyConfig name =
  let crawlers_api_key = Nothing
      crawlers = Nothing
      projects = Nothing
      idents = Nothing
      index = name
   in Config.Index {..}

withTenant :: TenantM () -> IO ()
withTenant cb = bracket create delete toTenantM
  where
    -- todo: generate random name
    testName = "test-tenant"
    create = do
      bhEnv <- I.mkEnv "http://localhost:9200"
      let config = emptyConfig testName
      _ <- runTenantM' bhEnv config I.ensureIndex
      pure (bhEnv, config)
    delete (bhEnv, config) = do
      BH.runBH bhEnv $ do
        let testIndex = tenantIndexName config
        _resp <- BH.deleteIndex testIndex
        False <- BH.indexExists testIndex
        pure ()
    toTenantM (bhEnv, config) = runTenantM' bhEnv config cb

checkELKChangeField :: (Show a, Eq a) => BH.DocId -> (ELKChange -> a) -> a -> TenantM ()
checkELKChangeField docId field value = do
  docM <- I.getDocument docId
  case docM of
    Just change -> assertEqual' "change field match" (field change) value
    Nothing -> error "Change not found"

checkChangesCount :: Int -> TenantM ()
checkChangesCount expectedCount = do
  index <- getIndexName
  resp <-
    BH.countByIndex
      index
      ( BH.CountQuery (BH.TermQuery (BH.Term "type" "Change") Nothing)
      )
  case resp of
    Left _ -> error "Couldn't count changes"
    Right countD -> assertEqual' "check change count" expectedCount (fromEnum $ BH.crCount countD)

testIndexChanges :: Assertion
testIndexChanges = withTenant doTest
  where
    doTest :: TenantM ()
    doTest = do
      -- Index two Changes and check present in database
      I.indexChanges [fakeChange1, fakeChange2]
      checkDocExists' $ I.getChangeDocId fakeChange1
      checkELKChangeField
        (I.getChangeDocId fakeChange1)
        elkchangeTitle
        (elkchangeTitle fakeChange1)
      checkDocExists' $ I.getChangeDocId fakeChange2
      checkELKChangeField
        (I.getChangeDocId fakeChange2)
        elkchangeTitle
        (elkchangeTitle fakeChange2)
      -- Update a Change and ensure the document is updated in the database
      I.indexChanges [fakeChange1Updated]
      checkDocExists' $ I.getChangeDocId fakeChange1
      checkELKChangeField
        (I.getChangeDocId fakeChange1Updated)
        elkchangeTitle
        (elkchangeTitle fakeChange1Updated)
      -- Check total count of Change document in the database
      checkChangesCount 2
      where
        checkDocExists' dId = do
          exists <- I.checkDocExists dId
          assertEqual' "check doc exists" exists True
        fakeChange1 = mkFakeChange 1 "My change 1"
        fakeChange1Updated = fakeChange1 {elkchangeTitle = "My change 1 updated"}
        fakeChange2 = mkFakeChange 2 "My change 2"

-- | A lifted version of assertEqual
assertEqual' :: (Eq a, Show a, MonadIO m) => String -> a -> a -> m ()
assertEqual' n a b = liftIO $ assertEqual n a b

testCrawlerMetadata :: Assertion
testCrawlerMetadata = withTenant doTest
  where
    doTest :: TenantM ()
    doTest = do
      -- Init default crawler metadata and Ensure we get the default updated date
      I.initCrawlerLastUpdatedFromWorkerConfig worker
      lastUpdated <- I.getLastUpdated worker entityType
      assertEqual' "check got oldest updated entity" fakeDefaultDate $ snd lastUpdated

      -- Update some crawler metadata and ensure we get the oldest (name, last_commit_at)
      I.setLastUpdated crawlerName fakeDateB entity
      I.setLastUpdated crawlerName fakeDateA entityAlt
      lastUpdated' <- I.getLastUpdated worker entityType
      assertEqual' "check got oldest updated entity" ("nova", fakeDateB) lastUpdated'

      -- Update one crawler and ensure we get the right oldest
      I.setLastUpdated crawlerName fakeDateC entity
      lastUpdated'' <- I.getLastUpdated worker entityType
      assertEqual' "check got oldest updated entity" ("neutron", fakeDateA) lastUpdated''

      -- Re run init and ensure it was noop
      I.initCrawlerLastUpdatedFromWorkerConfig worker
      lastUpdated''' <- I.getLastUpdated worker entityType
      assertEqual' "check got oldest updated entity" ("neutron", fakeDateA) lastUpdated'''
      where
        entityType = CrawlerPB.CommitInfoRequest_EntityTypeProject
        entity = Project "nova"
        entityAlt = Project "neutron"
        crawlerName = "test-crawler"
        worker =
          let name = crawlerName
              update_since = toText fakeDefaultDateStr
              provider =
                let gitlab_url = "https://localhost"
                    gitlab_api_key = "key"
                    gitlab_repositories = Just ["nova", "neutron"]
                    gitlab_organizations = Nothing
                 in Config.GitlabProvider Config.Gitlab {..}
           in Config.Crawler {..}
        fakeDefaultDateStr = "2020-01-01 00:00:00 Z"
        fakeDefaultDate = fromMaybe (error "nop") (readMaybe fakeDefaultDateStr :: Maybe UTCTime)
        fakeDateB = fromMaybe (error "nop") (readMaybe "2021-05-31 10:00:00 Z" :: Maybe UTCTime)
        fakeDateA = fromMaybe (error "nop") (readMaybe "2021-06-01 20:00:00 Z" :: Maybe UTCTime)
        fakeDateC = fromMaybe (error "nop") (readMaybe "2021-06-02 23:00:00 Z" :: Maybe UTCTime)

scenarioProject :: ScenarioProject
scenarioProject =
  SProject "openstack/nova" [Author "alice" "a", Author "bob" "b"] [Author "eve" "e"]

testAchievements :: Assertion
testAchievements = withTenant doTest
  where
    doTest :: TenantM ()
    doTest = do
      indexScenario (nominalMerge scenarioProject "42" fakeDate 3600)

      -- Try query
      agg <- head . fromMaybe (error "noagg") . nonEmpty <$> Q.getProjectAgg query
      assertEqual' "event found" (Q.epbType agg) "Change"
      assertEqual' "event count match" (Q.epbCount agg) 1
      where
        query = fromMaybe (error "oops") $ Q.queryBH $ Q.load Nothing mempty Nothing "state:open"

-- Tests scenario helpers

-- $setup
-- >>> import Data.Time.Clock
-- >>> let now = fromMaybe (error "") (readMaybe "2021-06-10 01:21:03Z")

-- | 'randomAuthor' returns a random element of the given list
randomAuthor :: (MonadRandom m) => [a] -> m a
randomAuthor xs = do
  let n = length xs
  i <- getRandomR (0, n -1)
  return (xs !! i)

emptyChange :: ELKChange
emptyChange = fakeChange

emptyEvent :: ELKChangeEvent
emptyEvent = ELKChangeEvent {..}
  where
    elkchangeeventId = mempty
    elkchangeeventNumber = 0
    elkchangeeventType = "ChangeMerged"
    elkchangeeventChangeId = mempty
    elkchangeeventUrl = mempty
    elkchangeeventChangedFiles = mempty
    elkchangeeventRepositoryPrefix = mempty
    elkchangeeventRepositoryShortname = mempty
    elkchangeeventRepositoryFullname = mempty
    elkchangeeventAuthor = fakeAuthor
    elkchangeeventOnAuthor = fakeAuthor
    elkchangeeventBranch = mempty
    elkchangeeventOnCreatedAt = fakeDate
    elkchangeeventApproval = Nothing

showEvents :: [ScenarioEvent] -> Text
showEvents xs = Text.intercalate ", " $ sort (map go xs)
  where
    author = toStrict . authorMuid
    date = toText . formatTime defaultTimeLocale "%Y-%m-%d"
    go ev = case ev of
      SChange ELKChange {..} -> "Change[" <> toStrict elkchangeChangeId <> "]"
      SCreation ELKChangeEvent {..} ->
        ("Change[" <> date elkchangeeventOnCreatedAt <> " ")
          <> (toStrict elkchangeeventChangeId <> " created by " <> author elkchangeeventAuthor)
          <> "]"
      SReview ELKChangeEvent {..} -> "Reviewed[" <> author elkchangeeventAuthor <> "]"
      SMerge ELKChangeEvent {..} -> "Merged[" <> date elkchangeeventOnCreatedAt <> "]"

-- Tests scenario data types

-- | 'ScenarioProject' is a data type to define a project for a scenario.
data ScenarioProject = SProject
  { name :: LText,
    maintainers :: [Author],
    contributors :: [Author]
  }

-- | 'ScenarioEvent' is a type of event generated for a given scenario.
data ScenarioEvent
  = SChange ELKChange
  | SCreation ELKChangeEvent
  | SReview ELKChangeEvent
  | SMerge ELKChangeEvent

toDoc :: ScenarioEvent -> (Value, BH.DocId)
toDoc se = case se of
  SChange e -> (toJSON e, I.getChangeDocId e)
  SCreation e -> (toJSON e, I.getEventDocId e)
  SReview e -> (toJSON e, I.getEventDocId e)
  SMerge e -> (toJSON e, I.getEventDocId e)

indexScenario :: [ScenarioEvent] -> TenantM ()
indexScenario xs = I.indexDocs $ fmap toDoc xs

-- | 'nominalMerge' is the most simple scenario
-- >>> let project = SProject "openstack/nova" [Author "alice" "a", Author "bob" "b"] [Author "eve" "e"]
-- >>> showEvents $ nominalMerge project "42" now (3600*24)
-- "Change[2021-06-10 change-2218 created by eve], Change[change-2218], Merged[2021-06-11], Reviewed[alice]"
nominalMerge :: ScenarioProject -> LText -> UTCTime -> Integer -> [ScenarioEvent]
nominalMerge SProject {..} elkchangeId start duration = evalRand scenario stdGen
  where
    -- The random number generator is based on the name
    stdGen = mkStdGen (Text.length (toStrict name))

    scenario = do
      -- The base change
      changeId <- getRandomR (1000, 9999)
      let mkDate elapsed =
            addUTCTime (secondsToNominalDiffTime (fromInteger elapsed)) start
          mkChange ts author =
            emptyChange
              { elkchangeType = "Change",
                elkchangeId = elkchangeId,
                elkchangeRepositoryFullname = name,
                elkchangeCreatedAt = mkDate ts,
                elkchangeAuthor = author,
                elkchangeChangeId =
                  "change-" <> show @LText @Int changeId
              }
          mkEvent ts etype author =
            emptyEvent
              { elkchangeeventAuthor = author,
                elkchangeeventId = etype,
                elkchangeeventOnCreatedAt = mkDate ts,
                elkchangeeventChangeId =
                  toLazy $ "change-" <> show @Text @Int changeId
              }

      -- The change creation
      author <- randomAuthor contributors
      let create = mkEvent 0 "ChangeCreatedEvent" author
          change = mkChange 0 author

      -- The review
      reviewer <- randomAuthor maintainers
      let review = mkEvent (duration `div` 2) "ChangeCommentedEvent" reviewer

      -- The change merged event
      approver <- randomAuthor maintainers
      let merge = mkEvent duration "ChangeMergedEvent" approver

      -- The event lists
      pure [SChange change, SCreation create, SReview review, SMerge merge]
