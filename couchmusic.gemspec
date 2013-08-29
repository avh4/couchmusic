Gem::Specification.new do |s|
  s.name        = 'couchmusic'
  s.version     = '0.0.0'
  s.date        = "#{Time.now.strftime '%Y-%m-%d'}"
  s.summary     = "Couch Music"
  s.description = "Rest easy--your music library is under control"
  s.authors     = ["Aaron VonderHaar"]
  s.email       = 'gruen0aermel@gmail.com'
  s.homepage    = 'http://github.com/avh4/couchmusic'
  s.license     = 'MIT'

  s.executables << 'couchmusic-add'

  s.add_dependency('system_keychain', '~> 1.0')
  s.add_dependency('colorize', '~> 0.5')
  s.add_dependency('couchrest', '~> 1.2')
  s.add_dependency('taglib-ruby', '~> 0.6')

  s.files       += Dir.glob("lib/**/*")
end