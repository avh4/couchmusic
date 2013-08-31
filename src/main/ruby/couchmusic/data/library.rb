module Couchmusic
  module Data
    class Library
      def initialize(config)
        @config = config
      end

      def gather(host, filename)
        host_config = @config.json[host.to_sym]
        return { } unless host_config
        libraries = host_config[:libraries]
        return { } unless libraries

        best_match = { }
        best_match_root_length = 0
        libraries.each do |lib, lib_root|
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
