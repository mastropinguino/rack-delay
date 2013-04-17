Gem::Specification.new do |s|
  s.name        = 'rack-delay'
  s.version     = '0.1.0'
  s.date        = '2013-04-17'
  s.platform    = Gem::Platform::RUBY
  s.summary     = %Q{#{ s.name } v#{ s.version }}
  s.description = %q{A simple rack middleware to slowdown response}
  s.authors     = ["Vincenzo Farruggia"]
  s.email       = 'mastropinguino@networky.net'
  s.files       = `git ls-files`.split($/)
  s.license     = 'MIT'
  s.require_paths = ['lib']
  s.add_runtime_dependency 'rack'
  s.homepage    =
    'https://github.com/mastropinguino/rack-delay'
end