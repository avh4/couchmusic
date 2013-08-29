require 'couchrest'
require 'colorize'

module Couchmusic
  module Visitor
    module LocalFiles
      def self.visit(db, &block)
        hostname = `hostname`.strip
        Dir.glob('./**/*.mp3') do |file|
          id = "#{hostname}:#{File.realpath(file)}"
          begin
            db.get(id)
            puts "Found #{id}".white
          rescue RestClient::ResourceNotFound => e
            song = { "_id" => id }
            new_data = yield id
            song.merge! new_data
            db.save_doc(song)
            puts "Adding #{id}".green
          end
        end
      end
    end
  end
end
