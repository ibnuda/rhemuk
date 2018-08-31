{-# LANGUAGE DeriveGeneric #-}
module Lib.Types where

import           Lib.Prelude

import qualified Data.ByteString.Char8 as BC
import           Data.Time
import           Web.Twitter.Types

import           Data.Csv

-- | "tweet_id" "6969420"
--   "in_reply_to_status_id" "",
--   "in_reply_to_user_id" ""
--   "timestamp" "2017-06-17 07:26:51 +0000"
--   "source""<a href=""http://twitter.com/download/android"" rel=""nofollow"">Twitter for Android</a>",
--   "text" "Lol. https://t.co/BLAZEIT",
--   "retweeted_status_id" ""
--   "retweeted_status_user_id" ""
--   "retweeted_status_timestamp" ""
--   "expanded_urls""https://twitter.com/something/status/4206969"
data Dump = Dump
  { dumpId                   :: StatusId
  , dumpReplyToId            :: Maybe StatusId
  , dumpReplyToUserId        :: Maybe UserId
  , dumpTimestamp            :: UTCTime
  , dumpSource               :: Text
  , dumpText                 :: Text
  , dumpRetweetStatId        :: Maybe StatusId
  , dumpRetweetStatUserId    :: Maybe UserId
  , dumpRetweetStatTimestamp :: Maybe UTCTime
  , dumpExpandedUrls         :: Text
  } deriving (Show)

instance FromField UTCTime where
  parseField = parsing
    where
      parsing = parseTimeM True defaultTimeLocale "%Y-%m-%d %T %z" . BC.unpack

instance FromRecord Dump where
  parseRecord m = Dump
    <$> m .! 0
    <*> m .! 1
    <*> m .! 2
    <*> m .! 3
    <*> m .! 4
    <*> m .! 5
    <*> m .! 6
    <*> m .! 7
    <*> m .! 8
    <*> m .! 9
