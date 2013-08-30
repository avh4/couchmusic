DB = 'http://localhost:5984/couchmusic-test-features'

Before do
  `curl -s -X DELETE #{DB}`
  `kanso push #{DB}`
  @web = Mechanize.new
end

Given(/^a song is on my local library$/) do
  `kanso upload fixtures/songs-mercury-feist.json #{DB}`
end

Given(/^that song is not on my master library$/) do
  # assert fixtures/songs-venus-feist.json is not uploaded
end

When(/^I view the list of files missing from local to master$/) do
  @page = @web.get "#{DB}/_design/couchmusic/_list/missing/track_identity?from=mercury&to=venus"
end

Then(/^I see that song$/) do
  @page.body.should include 'mercury:/Feist-Metals-04.mp3'
end
