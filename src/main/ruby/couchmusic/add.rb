require 'couchmusic/config'
require 'couchmusic/visitor/local_files'
require 'couchmusic/data/basic_info'
require 'couchmusic/data/library'

require 'couchrest'
require 'system_keychain'

module Couchmusic
  class Add
    def self.instance()
      config = Couchmusic::Config
      self.new(
        config,
        Couchmusic::Visitor::LocalFiles,
        [
          Couchmusic::Data::BasicInfo,
          Couchmusic::Data::Library.new(config)
        ]
      )
    end

    def initialize(config, visitor, datas)
      @config = config
      @visitor = visitor
      @datas = datas
    end

    def perform()
      db = connect
      visit db
    end

    private

    def connect()
      begin
        db = CouchRest.database!(@config.json[:db])
      rescue StandardError
        db = Keychain.authorize_url("couchmusic", @config[:db]) do |auth_url|
          CouchRest.database!(auth_url)
        end
      end

      db
    end

    def visit(db)
      @visitor.visit(db) do |host, filename|
        new_data = { }
        @datas.each do |data|
          new_data.merge! data.gather(host, filename)
        end
        new_data
      end
    end
  end
end

