module Lib.Plumbing where

import           Lib.Prelude

import           System.Environment

import qualified Data.ByteString.Char8      as C8

import           Web.Twitter.Conduit

getToken :: IO (OAuth, Credential)
getToken = do
  consumerKey       <- getEnv' "TWITTER_CONSUMER_KEY"
  consumerSecret    <- getEnv' "TWITTER_CONSUMER_SECRET"
  accessToken       <- getEnv' "TWITTER_ACCESS_TOKEN"
  accessTokenSecret <- getEnv' "TWITTER_ACCESS_TOKEN_SECRET"
  let oauth = twitterOAuth { oauthConsumerKey    = consumerKey
                           , oauthConsumerSecret = consumerSecret
                           }
      cred = Credential
        [ ("oauth_token"       , accessToken)
        , ("oauth_token_secret", accessTokenSecret)
        ]
  pure (oauth, cred)
  where getEnv' = (C8.pack <$>) . getEnv

getTwInfo :: IO TWInfo
getTwInfo = do
  (oauth, cred) <- getToken
  pure (setCredential oauth cred def)
