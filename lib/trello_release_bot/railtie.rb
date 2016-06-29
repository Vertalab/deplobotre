require 'trello_release_bot'
require 'rails'

module TrelloReleaseBot
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path('../../tasks/trello.rake', __FILE__)
    end
  end
end
