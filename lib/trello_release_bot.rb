require 'trello_release_bot/base'
require 'trello_release_bot/git_logger'
require 'trello_release_bot/trello_bot'
require 'trello_release_bot/tasks'

module TrelloReleaseBot
  CARD_URL_REG = /cid#[^ ]*/
  USER_NAME_REG = /un#[^ ]*/

  def self.configure
    yield Base.config
  end

  # @param [String] branch name
  # @param [Time] since time
  def self.generate_release(repo_path, revission_rage, branch)
    commits = GitLogger.commits(repo_path, revission_rage)
    return if commits.empty?

    target_list_name = "Releases - #{Rails.env.capitalize}"
    trello_bot = TrelloBot.new
    list = trello_bot.find_list(target_list_name) || trello_bot.create_list(target_list_name)
    label = trello_bot.find_label(Rails.env) || trello_bot.create_label(Rails.env)
    commits_text = "**Commits:**\n\n"
    cards_text = "**Cards:**\n\n"
    members_text = "**Contributors:**\n\n"
    members = []
    cards = []

    commits.each do |commit|
      card_short_link = serch_in_commit(commit, CARD_URL_REG).split('#').last
      user_name       = serch_in_commit(commit, USER_NAME_REG).split('#').last
      member          = trello_bot.find_member(user_name)
      card            = trello_bot.find_card(card_short_link)
      commits_text += commit_line(commit)
      members.push(member) if member
      cards.push(card) if card
    end

    cards.uniq.each do |card|
      cards_text += card_line(card)
    end

    members.uniq.each do |member|
      members_text += member_line(member)
    end

    texts = []
    texts.push(members_text) if members.any?
    texts.push(cards_text)   if cards.any?
    texts.push(commits_text)

    card_name = Time.current.utc.to_s
    member_ids = members.uniq.map { |member| member['id'] }
    release_card = trello_bot.create_card(list['id'], card_name, texts.join("\n\n"), member_ids)
    commend_card_text = "This card was deployed to [**#{Rails.env}**](#{release_card['shortUrl']})"

    cards.uniq.each do |card|
      trello_bot.comment_card(card['id'], commend_card_text)
      unless card['labels'].find { |l| l['id'] == label['id'] }
        trello_bot.add_card_label(card['id'], label['id'])
      end
    end

    release_card
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
    "- @#{member['username']}"
  end

  def self.serch_in_commit(commit, regexp)
    commit[:message][regexp].to_s
  end
end
