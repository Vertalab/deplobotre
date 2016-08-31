require 'trello_release_bot/base'
require 'trello_release_bot/config'
require 'trello_release_bot/git_logger'
require 'trello_release_bot/trello_bot'
require 'trello_release_bot/railtie' if defined?(Rails)

module TrelloReleaseBot
  CARD_URL_REG = /cid#[^ ]*/
  USER_NAME_REG = /un#[^ ]*/
  MENTION_BOARD_MEMBERS_TEXT = '@board'.freeze
  TEXT_DIVIDER = "\n____________\n".freeze

  def self.configure
    yield Base.config
  end

  # @param [Hash] options
  # @option opts [String] :repo_path, path to git repo
  # @option opts [String] :revission_rage, for git logs
  # @option opts [String] :application, name of application
  # @option opts [Array] :servers, servers to which release is deployed to
  def self.generate_release(options)
    commits = GitLogger.commits(options[:repo_path], options[:revission_rage])
    return if commits.empty?

    target_list_name = "Releases - #{Rails.env.capitalize}"
    trello_bot = TrelloBot.new
    list = trello_bot.find_list(target_list_name) || trello_bot.create_list(target_list_name)
    label = trello_bot.find_label(Rails.env) || trello_bot.create_label(Rails.env)
    servers_text = "**Servers:**\n\n"
    commits_text = "**Commits:**\n\n"
    cards_text = "**Cards:**\n\n"
    members_text = "**Contributors:**\n\n"
    members = []
    cards = []

    options[:servers].each do |server_link|
      servers_text += server_line(server_link)
    end

    commits.each do |commit|
      card_short_link = serch_in_commit(commit, CARD_URL_REG).split('#').last
      user_name       = serch_in_commit(commit, USER_NAME_REG).split('#').last
      member          = trello_bot.find_member(user_name)
      card            = trello_bot.find_card(card_short_link)
      commits_text += commit_line(commit)
      members.push(member) if member
      cards.push(card) if card
    end

    cards.uniq!
    members.uniq!

    cards.each do |card|
      cards_text += card_line(card)
    end

    members.each do |member|
      members_text += member_line(member)
    end

    texts = []
    texts.push(servers_text) if servers.any?
    texts.push(members_text) if members.any?
    texts.push(cards_text)   if cards.any?
    texts.push(commits_text)

    card_name = Time.current.utc.strftime("#{options[:application]} | %Y-%m-%d")
    member_ids = members.map { |member| member['id'] }
    release_card = trello_bot.create_card(list['id'], card_name, texts.join(TEXT_DIVIDER), member_ids)
    commend_card_text = "This card was deployed to [**#{Rails.env}**](#{release_card['shortUrl']})"

    cards.each do |card|
      trello_bot.comment_card(card['id'], commend_card_text)
      unless card['labels'].find { |l| l['id'] == label['id'] }
        trello_bot.add_card_label(card['id'], label['id'])
      end
    end

    trello_bot.comment_card(release_card['id'], MENTION_BOARD_MEMBERS_TEXT)

    release_card
  end

  def self.server_line(server_link)
    "- [#{server_link}](#{server_link})\n"
  end

  def self.commit_line(commit)
    return 'commit' if commit[:message].blank?
    message = commit[:message].remove(serch_in_commit(commit, CARD_URL_REG))
    message = message.blank? ? 'commit' : message
    url = "#{Base.config.commits_url}/#{commit[:id]}"
    "- [#{message}](#{url})\n"
  end

  def self.card_line(card)
    return '' if card.blank?
    "- [#{card['name']}](#{card['shortUrl']})\n"
  end

  def self.member_line(member)
    return '' if member.blank?
    "- **#{member['username']}**\n"
  end

  def self.serch_in_commit(commit, regexp)
    return '' if commit.blank? || commit[:message].blank?
    commit[:message][regexp].to_s
  end
end
