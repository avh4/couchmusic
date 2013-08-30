Feature: List missing files
As a music listener with multiple music libraries
I want to see which files are missing from one library to another
So that I can copy the missing files to the other library

Scenario: Local files not in the master library
  Given a song is on my local library
  And that song is not on my master library
  When I view the list of files missing from local to master
  Then I see that song
