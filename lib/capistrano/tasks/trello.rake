require_relative '../../trello_release_bot'

namespace :trello do
  desc 'Creates Trello Card with release info'
  task :create_release do
    next unless fetch(:stage).eql? :staging
    servers = []
    on roles(:all) do |server|
      servers << server.hostname
      puts "Pegou os servers: #{servers}"
    end
      run_locally do
        puts "entrou no run_locally new"
        # rake_args = "#{},#{revission_rage},#{},#{servers}"
        # system "rake trello_release_bot:create_release\[#{rake_args}\]"
        # servers = args[:servers].match(/\[(.*?)\]/).to_s[1...-1].split(',')
        TrelloReleaseBot.generate_release(
          repo_revision: fetch(:repo_revision),
          revission: `git rev-parse origin/#{fetch(:branch)}`.strip! ,
          application: fetch(:application),
          servers: servers
        )
        puts "saindo so locally"
      end
  end

  task :add_default_hooks do
    after 'deploy:finished', 'trello:create_release'
  end
end

namespace :deploy do
  before :starting, :check_trello_hooks do
    invoke 'trello:add_default_hooks'
  end
end
