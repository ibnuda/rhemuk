{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase       #-}
{-# LANGUAGE RecordWildCards  #-}
module Lib.Internal where

import           Lib.Prelude

import qualified Data.ByteString.Lazy as BL
import           Data.Csv
import           Data.Text            (pack)
import           Data.Time
import           Data.Vector          (Vector)

import           Web.Twitter.Conduit
import           Web.Twitter.Types

import           Lib.Types


decodeDump :: BL.ByteString -> Either [Char] (Vector Dump)
decodeDump = decode HasHeader

catchFish :: IO a -> IO (Either [Char] a)
catchFish act = fmap Right act `catch` handleIOException
 where
  handleIOException :: IOException -> IO (Either [Char] a)
  handleIOException = pure . Left . show

readTweetFile :: FilePath -> IO (Either [Char] (Vector Dump))
readTweetFile fn = catchFish (BL.readFile fn) >>= pure . either Left decodeDump

-- | The main shit.
doAndDelay
  :: (Show a, Foldable t)
  => (Dump -> IO a) -- ^ Function to be called.
  -> t Dump -- ^ Dumps.
  -> Maybe UTCTime -- ^ Pre date.
  -> Maybe UTCTime -- ^ Post date.
  -> IO ()
doAndDelay fun dumps pre post = do
  forM_ dumps $ \a@Dump {..} -> do
    case (pre, post) of
      (Nothing, Nothing) -> actuallydoit a
      (Just pr, Nothing)
        | dumpTimestamp < pr -> actuallydoit a
        | otherwise          -> putText $ "skipping " <> (pack . show $ dumpId)
      (Nothing, Just po)
        | dumpTimestamp > po -> actuallydoit a
        | otherwise          -> putText $ "skipping " <> (pack . show $ dumpId)
      (Just pr, Just po)
        | dumpTimestamp > po && dumpTimestamp < pr -> actuallydoit a
        | otherwise -> putText $ "skipping " <> (pack . show $ dumpId)
 where
  actuallydoit x = do
    threadDelay 500000
    putStr $ "Deleting from " ++ (show $ dumpTimestamp x)
    fun x >>= putText . pack . show

deleteTweet :: TWInfo -> Manager -> Dump -> IO Status
deleteTweet twinfo mnger = call twinfo mnger . destroyId . dumpId

parseDumps :: FilePath -> IO (Vector Dump)
parseDumps tweetcsv = readTweetFile tweetcsv >>= \case
  (Left  x    ) -> panic . pack $ x
  (Right dumps) -> pure dumps

parseTimeSimple :: [Char] -> Maybe UTCTime
parseTimeSimple = parseTimeM True defaultTimeLocale "%Y-%m-%d"
