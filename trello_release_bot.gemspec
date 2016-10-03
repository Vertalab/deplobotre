Gem::Specification.new do |s|
  s.name          = 'trello_release_bot'
  s.version       = '0.2.3'
  s.authors       = ['Roman Dumitro']
  s.email         = ['roman@vertalab.com']

  s.summary       = 'Integrate cap after deploy hook with Trello'
  s.description   = 'Integrate cap after deploy hook with Trello'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.require_paths = ['lib']

  s.add_dependency 'capistrano', '>= 3.0'
  s.add_dependency 'rake', '>= 10.0'
  s.add_dependency 'rest-client'
end
