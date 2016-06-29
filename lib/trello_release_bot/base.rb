module TrelloReleaseBot
  class Base
    # Returns (and initialize if needed) a TrelloReleaseBot::Config instance
    #
    # @return [TrelloReleaseBot::Config] the current config instance.
    def self.config
      @config ||= Config.new
    end
  end
end
