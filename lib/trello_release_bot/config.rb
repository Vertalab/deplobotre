module TrelloReleaseBot
  class Config
    attr_accessor :trello_token, :trello_key, :board_id, :commits_url

    def initialize
      @commits_url = nil
      @trello_token = nil
      @trello_key = nil
      @board_id = nil
    end
  end
end
