require 'taglib'

module Couchmusic
  module Data
    module BasicInfo
      def self.gather(host, filename)
        TagLib::FileRef.open(filename) do |ref|
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
  end
end
