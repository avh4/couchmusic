require 'couchmusic/config'
require 'couchmusic/runner'
require 'couchmusic/visitor/errors'
require 'couchmusic/visitor/local_files'
require 'couchmusic/data/basic_info'
require 'couchmusic/data/library'

module Couchmusic
  module Commands
    @config = Couchmusic::Config

    def self.add
      Couchmusic::Runner.new(@config,
        Couchmusic::Visitor::LocalFiles, [
          Couchmusic::Data::BasicInfo,
          Couchmusic::Data::Library.new(@config)
        ])
    end

    def self.update_libraries
      Couchmusic::Runner.new(@config,
        Couchmusic::Visitor::Errors.new("Missing library"), [
          Couchmusic::Data::Library.new(@config)
        ])
    end
  end
end