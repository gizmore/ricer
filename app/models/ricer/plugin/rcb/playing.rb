module Ricer::Plugin::Rcb
  class Playing < Ricer::Plug::Trigger
    
    has_setting :last_played, type: :string,  scope: :bot,     permission: :responsible, default: ''
    has_setting :announce,    type: :boolean, scope: :channel, permission: :operator,    default: false

    # Single thread!    
    def ricer_on_global_startup
      last = setting(:last_played)
      Ricer::Thread.new do |t|
        sleep 10.seconds
        while true
          playing = RcbSong.currently_playing
          if playing != nil && playing.title != last 
            last = playing.title
            new_song_playing(playing)
          end
          sleep 60.seconds
        end
      end
    end
    
    def new_song_playing(song)
      setting(:last_played, :bot, song.title)
      RcbPlayedSong.now_playing song
      announce_new_song(song)
    end
    
    def announce_new_song(song)
      bot.servers.each do |server|
        server.joined_channels.each do |k,channel|
          if channel_setting(channel, :announce)
            channel.localize!.send_privmsg tp(:msg_now_playing, :title => song.title, :length => song.displaylength)
          end
        end
      end
    end
    
    def execute
      argc == 0 ? now_playing : history(argv[0])
    end
    
    def now_playing
      song = RcbSong.current_song
      return rplyp :err_none_playing if song.nil?
      return rplyp :msg_now_playing, :title => song.title, :length => song.displaylength
    end
    
    def history(page)
      out = []
      history = RcbPlayedSong.order('played_at DESC').page(page).per(5)
      history.each do |rps|
        out.push("#{rps.rcb_song.title}")
      end
      return rply :err_empty_page if out.length == 0
      rply :msg_history_page, page:history.current_page, pages:history.total_pages, out:out.join(', ')
    end
    
  end
end
