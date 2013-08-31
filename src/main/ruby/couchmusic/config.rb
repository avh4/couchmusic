require 'json'

module Couchmusic
  module Config
    @config_file = ENV['HOME']+'/.couchmusic.json'

    def self.hostname()
      @hostname ||= `hostname`.strip
    end

    def self.json
      @json ||= JSON.parse(IO.read(@config_file), :symbolize_names => true)
    end
  end
end
