Given(/^a song is on my local library$/) do
  `kanso upload fixtures/songs-mercury-feist.json #{DB}`
end

Given(/^that song is not on my master library$/) do
  # assert fixtures/songs-venus-feist.json is not uploaded
end

When(/^I view the list of files missing from local to master$/) do
  visit "#{DB}/_design/couchmusic/_list/missing/track_identity?from=mercury&to=venus"
end

Then(/^I see that song$/) do
  page.should have_content 'mercury:/Feist-Metals-04.mp3'
end
