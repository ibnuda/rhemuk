module Lib
  ( someFunc
  ) where

import           Lib.Prelude

import           ReadArgs
import           Web.Twitter.Conduit

import           Lib.Internal
import           Lib.Plumbing

someFunc :: IO ()
someFunc = do
  twinfo                <- getTwInfo
  manager               <- newManager tlsManagerSettings
  (tweetcsv, pre, post) <- readArgs
  dumps                 <- parseDumps tweetcsv
  doAndDelay (deleteTweet twinfo manager)
             dumps
             (parseTimeSimple =<< pre)
             (parseTimeSimple =<< post)
