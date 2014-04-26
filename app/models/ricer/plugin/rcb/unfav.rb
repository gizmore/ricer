module Ricer::Plugin::Rcb
  class Unfav < Ricer::Plug::Trigger
    
    def execute

      song = RcbSong.current_song
      return rplyp :err_none_playing if song.nil?
      
    end
    
  end
end
