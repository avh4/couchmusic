#!/usr/bin/env ruby

require 'json'
require 'couchrest'
require 'taglib'
require 'colorize'
require 'system_keychain'

@config = JSON.parse(IO.read(ENV['HOME']+'/.couchmusic.json'), :symbolize_names => true)

@db = Keychain.authorize_url("couchmusic", @config[:db]) do |auth_url|
  CouchRest.database!(auth_url)
end

module BasicInfo
  def self.gather(id)
    hostname, file = id.split(':', 2)
    TagLib::FileRef.open(file) do |ref|
      tag = ref.tag
      {
        :length => ref.audio_properties.length,
        :bitrate => ref.audio_properties.bitrate,
        :channels => ref.audio_properties.channels,
        :sample_rate => ref.audio_properties.sample_rate,
        :title  => tag.title,
        :album  => tag.album,
        :artist => tag.artist,
        :track  => tag.track,
        :year   => tag.year
      }
    end
  end
end

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

LocalFiles.visit(@db) {|id| BasicInfo.gather(id)}

