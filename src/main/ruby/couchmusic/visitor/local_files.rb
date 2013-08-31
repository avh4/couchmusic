require 'couchrest'
require 'colorize'

module Couchmusic
  module Visitor
    module LocalFiles
      def self.visit(db, &block)
        host = `hostname`.strip
        Dir.glob('./**/*.mp3') do |file|
          filename = File.realpath(file)
          id = "#{host}:#{filename}"
          begin
            db.get(id)
            puts "Found #{id}".white
          rescue RestClient::ResourceNotFound => e
            song = { "_id" => id }
            new_data = yield host, filename
            song.merge! new_data
            db.save_doc(song)
            puts "Adding #{id}".green
          end
        end
      end
    end
  end
end
