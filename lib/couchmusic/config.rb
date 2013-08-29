require 'json'

module Couchmusic
  module Config
    @json = JSON.parse(IO.read(ENV['HOME']+'/.couchmusic.json'), :symbolize_names => true)
    def self.[](ind)
      @json[ind.to_sym]
    end
  end
end
