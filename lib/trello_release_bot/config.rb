# https://trello.com/1/authorize?key=783c46fbd960ab4a1f4acbe9de3a38f3&name=DeployBot&expiration=never&response_type=token&scope=read,write,account
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
