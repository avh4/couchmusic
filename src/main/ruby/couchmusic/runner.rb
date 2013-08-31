require 'couchmusic/config'
require 'couchmusic/database'

module Couchmusic
  class Runner
    def initialize(config, visitor, datas)
      @config = config
      @visitor = visitor
      @datas = datas
    end

    def perform()
      db = Couchmusic::Database.connect(@config)
      visit db
    end

    private

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

