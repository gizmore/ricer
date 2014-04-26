require 'net/http'
require 'nokogiri'

module Ricer::Plugin::Rcb
  class RcbSong < ActiveRecord::Base
    
    PLAYLIST_URL = 'http://217.172.180.6:8024/played.html'
    
    has_many :rcb_played_songs
    has_many :rcb_song_favs
    
    attr_accessor :playing_started_at
    
    def self.current_song
      begin
        song = @@CURRENTLY_PLAYING
        return nil if song.last_played_at.to_i < (Time.now.to_i - song.length)
        return song
      rescue => e
        return nil
      end
    end
    
    def last_played_at
      rcb_played_songs.order('played_at DESC').first.played_at
    end
    
    def self.upgrade_1
      m = ActiveRecord::Migration.new
      m.create_table :rcb_songs do |t|
        t.string  :title,     :null => false
        t.integer :length,    :null => false
        t.integer :favcount,  :null => false, :default => 0
        t.integer :playcount, :null => false, :default => 0
      end
      m.add_index :rcb_songs, :title, :name => :rcb_song_name_index
    end

    search_syntax do
      search_by :text do |scope, phrases|
        columns = [:title]
        scope.where_like(columns => phrases)
      end
    end
    
    def self.by_title(title)
      where(:title => title).first
    end
    
    def self.currently_playing
      return nil
      begin
        @@URI ||= URI(PLAYLIST_URL)
        @@HTTP ||= Net::HTTP.new(@@URI.host, @@URI.port)
        @@REQUEST = Net::HTTP::Get.new(@@URI)
        @@REQUEST.add_field('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:27.0) Gecko/20100101 Firefox/27.0')
        response = @@HTTP.request @@REQUEST
        if response.code == '200'
          song = parse_currently_playing(response.body)
          @@CURRENTLY_PLAYING = song unless song.nil?
          return song
        end
      rescue => e
        puts "RcbSong.currently_playing ERORR"
        puts e.message
        puts e.backtrace
      end
      return nil
    end
    
    def self.parse_currently_playing(html)
      begin
        doc = Nokogiri::HTML(html, nil, 'windows-1252')
        td = doc.css('table[cellspacing="2"] tr + tr > td + td').first.content
        match = /^(.*) \(?:([0-9:]+)\)$/.match(td)
        return nil if match.nil?
        already_known = self.by_title(match[1])
        return already_known unless already_known.nil?
        RcbSong.create!({
          title: match[1],
          length: parse_length(match[2]),
        })
      rescue => e
        nil
      end
    end
    
    def self.parse_length(length)
      return 300 if length.nil?
      minutes = length.substr_to(':').to_i.minutes
      seconds = length.substr_from(':').to_i.seconds
      minutes + seconds
    end
    
    def displaylength
      minutes = (length / 60).to_s
      seconds = (length % 60).to_s
      seconds = '0' + seconds if seconds.length == 1
      "#{minutes}:#{seconds}"
    end
        
  end
end
