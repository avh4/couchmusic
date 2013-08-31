require 'couchrest'

module Couchmusic
  module Visitor
    class Errors
      def initialize(error)
        @error = error
      end

      def visit(db, &block)
        doc = db.view('couchmusic/errors',
          reduce: false,
          startkey: [@error],
          endkey: ["#{@error}\u9999"])

        doc['rows'].each do |row|
          id = row['id']
          host, path = id.split(':', 2)
          song = db.get(id)
          new_data = yield host, path
          song.merge! new_data
          db.save_doc(song)
          puts "Updated #{id}".blue
        end
      end
    end
  end
end
