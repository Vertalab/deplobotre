# Trello Release Bot

After each `cap deploy` this bot creates trello card with information about deploy

## Installation

In `Gemfile`:

```
#!ruby
gem 'trello_release_bot', git: 'git@bitbucket.org:vertaline/deplobotre.git'
```

In `config/initializers/trello_release_bot.rb`

```
#!ruby
TrelloReleaseBot.configure do |config|
  config.commits_url = 'https://bitbucket.org/vertaline/deplobotre/commits' # base url for repo commits
  config.trello_token = TRELLO_TOKEN # Trello token with read, write and accout access to the Trello Board
  config.trello_key = TRELLO_API_KEY # [https://trello.com/app-key](https://trello.com/app-key)
  config.board_id = TRELLO_BOARD_ID
end
```

NOTE: link to generate token:

`https://trello.com/1/authorize?key=TRELLO_API_KEY&name=DEPLOY_BOT_NAME&expiration=never&response_type=token&scope=read,write,account`


## How to track cards and users

To track cards activity just add in commit message Trello card shortLink, for example for card:

`https://trello.com/c/zxqgpGTd/example-card`

shortLink is `zxqgpGTd`

`cid#zxqgpGTd` - include in commit message

and to track user with Trello username "USER_NAME" include in commit:

`un#USER_NAME`

So commit message must be like this:

`cid#zxqgpGTd un#USER_NAME YOUR MASSAE`
