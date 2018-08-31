# rhemuk

Delete tweets from your timeline, including tweets
beyond the [3,200 tweet limit](https://web.archive.org/web/20131019125213/https://dev.twitter.com/discussions/276).

## Prerequisites

### Configure API access

1. Open Twitter's [Application Management](https://apps.twitter.com/), and create
  a new Twitter app.
1. Set the permissions of your app to *Read and Write*.
1. Set the required environment variables:

```bash
TWITTER_CONSUMER_KEY="[your consumer key]"
TWITTER_CONSUMER_SECRET="[your consumer secret]"
TWITTER_ACCESS_TOKEN="[your access token]"
TWITTER_ACCESS_TOKEN_SECRET="[your access token secret]"
```

### Get your tweet archive

1. Open your [Twitter account page](https://twitter.com/settings/account).
1. Scroll to the bottom of the page, click 'Request your archive' (not 'Your Twitter
  data' in the left sidebar!), and wait for the email to arrive.
1. Follow the link in the email to download your Tweet archive.
1. Unpack the archive and move `tweets.csv` somewhere else, like `$HOME`.

## Installation

Install [stack](https://docs.haskellstack.org/en/stable/README/) and do the following:

```
stack build; stack install; source ~/.zshrc # or whatever equivalent your shell has
```

## Usage

To delete any tweet from before *2014 January 1*:

```bash
rhemuk your-tweet-csv-file.csv 2014-01-01
```

To delete any tweet after *2014 January 1*

```bash
rhemuk your-tweet-csv-file.csv "" 2014-01-01 # please note the empty quotation
```

To delete any tweet in between *2013 December 1* and *2013 December 31*

```bash
rhemuk your-tweet-csv-file.csv 2013-12-31 2013-12-01
```

And to delete all tweets

```bash
rhemuk your-tweet-csv-file.csv
```
