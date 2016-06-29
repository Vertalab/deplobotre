namespace :trello do
  task :create_release, [:repo_path, :revission_rage, :branch] => :environment do |_t, args|
    TrelloReleaseBot.generate_release(args[:repo_path], args[:revission_rage], args[:branch])
  end
end
