#!/usr/bin/env ruby

require 'json'
require 'couchrest'
require 'taglib'
require 'colorize'

@config = JSON.parse(IO.read(ENV['HOME']+'/.couchmusic.json'), :symbolize_names => true)

pass, user = `security find-generic-password -s couchmusic -g 2>&1`.match(/password: "([^"]*)".*acct"<blob>="([^"]*)"/m).captures
@db = CouchRest.database!(@config[:db].sub('http://',"http://#{user}:#{pass}@"))

module BasicInfo
  def self.gather(file)
    TagLib::FileRef.open(file) do |ref|
      tag = ref.tag
      {
        :length => ref.audio_properties.length,
        :bitrate => ref.audio_properties.bitrate,
        :channels => ref.audio_properties.channels,
        :sample_rate => ref.audio_properties.sample_rate,
        :title  => tag.title,
        :album  => tag.artist,
        :artist => tag.album,
        :track  => tag.track,
        :year   => tag.year
      }
    end
  end
end

hostname = `hostname`.strip
Dir.glob('./**/*.mp3') do |file|
  id = "#{hostname}:#{File.realpath(file)}"
  begin
    @db.get(id)
    puts "Found #{id}".white
  rescue RestClient::ResourceNotFound => e
    song = { "_id" => id }
    song.merge! BasicInfo.gather(file)
    @db.save_doc(song)
    puts "Adding #{id}".green
  end
end
