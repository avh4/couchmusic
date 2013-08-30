require 'couchmusic/config'
require 'couchmusic/visitor/local_files'
require 'couchmusic/data/basic_info'

require 'couchrest'
require 'system_keychain'

module Couchmusic
  module Add
    @config = Couchmusic::Config
    @visitor = Couchmusic::Visitor::LocalFiles
    @data = Couchmusic::Data::BasicInfo

    def self.perform()
      begin
        db = CouchRest.database!(@config[:db])
      rescue StandardError
        db = Keychain.authorize_url("couchmusic", @config[:db]) do |auth_url|
          CouchRest.database!(auth_url)
        end
      end

      @visitor.visit(db) {|id| @data.gather(id)}
    end
  end
end

