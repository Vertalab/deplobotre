require 'trello_release_bot'
require 'rails'

module TrelloReleaseBot
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'trello_release_bot/tasks/trello.rake'
    end
  end
end
