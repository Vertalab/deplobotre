namespace :trello do
  desc 'Creates Trello Card with release info'
  task :create_release do
    next unless fetch(:stage).eql? :release
    servers = []
    on roles(:all) do |server| 
      servers << server.hostname
      puts "Pegou os servers: #{servers}"
    end
    run_locally do
      puts "entrou no run_locally"
      revission_rage = "#{fetch(:previous_revision)}..#{fetch(:current_revision)}"
      rake_args = "#{fetch(:repo_path)},#{revission_rage},#{fetch(:application)},#{servers}"
      execute "bundle exec rake trello_release_bot:create_release\[#{rake_args}\]"
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
