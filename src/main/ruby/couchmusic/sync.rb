require 'couchmusic/config'

module Couchmusic
  module Sync
    @config = Couchmusic::Config

    def self.perform()
      # ssh -L 22222:localhost:5984 avh4@artemis-2.local.
      # replicate both ways
      # curl -s localhost:5984/_active_tasks
    end
  end
end