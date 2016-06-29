Gem::Specification.new do |s|
  s.name          = 'trello-release-bot'
  s.version       = '0.0.1'
  s.authors       = ['Roman Dumitro']
  s.email         = ['roman@vertalab.com']

  s.summary       = 'Integrate cap after deploy hook with Trello'
  s.description   = 'Integrate cap after deploy hook with Trello'
  # s.homepage    = 'http://rubygems.org/gems/replace-me'
  s.license       = 'MIT'

  s.files         = ['lib/trello_release_bot.rb']
  s.require_paths = ['lib']

  s.add_dependency 'capistrano', '~> 3.0'
  s.add_dependency 'rake', '~> 10.0'
end
