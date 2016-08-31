namespace :trello_release_bot do
  desc 'Runs Trello release bot'
  task :create_release, [:repo_path, :revission_rage, :application, :servers] => :environment do |_t, args|
    servers = args[:servers].match(/\[(.*?)\]/).to_s[1...-1].split(',')

    TrelloReleaseBot.generate_release(
      repo_path: args[:repo_path],
      revission_rage: args[:revission_rage],
      application: args[:application],
      servers: servers
    )
  end
end
