module TrelloReleaseBot
  class Config
    attr_accessor :trello_token, :trello_key, :board_id

    def initialize
      @trello_token = fetch(:trello_token)
      @trello_key = fetch(:trello_key)
      @board_id = fetch(:board_id)
    end
  end
end
