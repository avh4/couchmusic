module Couchmusic
  module Data
    class Library
      def initialize(config)
        @hostname = config.hostname
        @libraries = config.json[:libraries]
      end

      def gather(host, filename)
        return {} unless host == @hostname

        best_match = { }
        best_match_root_length = 0
        @libraries.each do |lib, lib_root|
          unmatched_prefix, relative_path = filename.split(lib_root, 2)
          if unmatched_prefix == ''
            if (lib_root.size > best_match_root_length)
              best_match_root_length = lib_root.size
              best_match = {
                library: lib,
                library_path: relative_path
              }
            end
          end
        end

        return best_match
      end
    end
  end
end
