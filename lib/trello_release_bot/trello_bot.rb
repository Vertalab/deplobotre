module TrelloReleaseBot
  class TrelloBot
    BASE_URL = 'https://api.trello.com/1'.freeze

    def initialize
      @key = Base.config.trello_key
      @token = Base.config.trello_token
      @board_id = Base.config.board_id
      puts "#{@key}, #{@token}, #{@board_id}"
    end

    def board
      @board ||= fetch_board
    end

    # @param [String] trello list id
    # @param [String] name of a new card
    # @param [String] description of a new card
    def create_card(list_id, name, desc, members_ids = [])
      post_data = {
        idList: list_id,
        name: name,
        desc: desc,
        idMembers: members_ids,
        pos: 'top'
      }
      resource('cards', :post, post_data)
    end

    # @param [String] card_id or shortLink
    def comment_card(card_id, text)
      resource("cards/#{card_id}/actions/comments", :post, text: text)
    end

    def add_card_label(card_id, label_id)
      resource("cards/#{card_id}/idLabels", :post, value: label_id)
    end

    def create_list(name)
      resource("boards/#{board['id']}/lists", :post, name: name)
    end

    def create_label(name)
      post_data = {
        name: name,
        color: 'null'
      }
      resource("boards/#{board['id']}/labels", :post, post_data)
    end

    def find_card(card_short_link)
      board['cards'].find { |card| card['shortLink'] == card_short_link }
    end

    def find_list(list_name)
      board['lists'].find { |list| list['name'] == list_name }
    end

    def find_member(user_name)
      board['members'].find { |member| member['username'] == user_name }
    end

    def find_label(label_name)
      board['labels'].find { |label| label['name'] == label_name }
    end

    private

    def fetch_board
      query_hash = {
        fields: 'name',
        lists: 'open',
        list_fields: 'name',
        cards: 'open',
        card_fields: 'shortLink,shortUrl,name,labels',
        members: 'all',
        member_fields: 'username',
        labels: 'all',
        label_fields: 'name'
      }
      resource("/board/#{@board_id}", :get, query_hash)
    end

    def resource(path, method = :get, params = {})
      params[:key] = @key
      params[:token] = @token
      puts "#{params}"
      res = RestClient::Request.execute(
        method: method,
        url: "#{BASE_URL}/#{path}?#{params.to_query}",
        headers: { 'Content-Type' => 'application/json' }
      )
      JSON.parse(res)
    end
  end
end
