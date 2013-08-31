require 'couchmusic/config'

require 'couchrest'
require 'system_keychain'

module Couchmusic
  module Database
    def self.connect(config = Couchmusic::Config)
      url = config.json[config.hostname.to_sym][:db]
      begin
        db = CouchRest.database!(url)
      rescue StandardError
        db = Keychain.authorize_url("couchmusic", url) do |auth_url|
          CouchRest.database!(auth_url)
        end
      end
      db
    end
  end
end