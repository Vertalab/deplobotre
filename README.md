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
