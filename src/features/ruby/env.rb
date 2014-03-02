require 'rspec/expectations'

require 'capybara/poltergeist'
require 'capybara/cucumber'
Capybara.default_driver = :poltergeist

DB = 'http://localhost:5984/couchmusic-test-features'

puts "===> Deploying to #{DB}"
`curl -s -X DELETE #{DB}`
`kanso push #{DB}`


World(RSpec::Matchers)
