module Ricer::Plugin::Rcb
  class Fav < Ricer::Plug::Trigger
    
    def self.upgrade_1; RcbSong.upgrade_1; RcbSongFav.upgrade_1; RcbPlayedSong.upgrade_1; end
    
    def execute
      argc == 0 ? mark_fav : fav_sub(argv[0])
    end
    
    private
    
    def mark_fav
      song = RcbSong.current_song
      return rplyp :err_none_playing if song.nil?
      fav = RcbSongFav.favorize(user, song)
      rply :msg_faved, title:song.title, level:fav.level
    end
    
    def fav_sub(cmd)
      case cmd
      when 'topten'; topten
      when 'mostplayed'; mostplayed
      else; show_help
      end
    end
    
    def topten
      page = argc == 1 ? 1 : argv[1]
      songs = RcbSong.order('favcount DESC').page(page).per(5)
      return rply :err_empty_page if songs.count == 0
      rank = (songs.current_page-1) * 5
      out = []
      songs.each do |song|
        rank += 1
        out.push("#{rank}.#{song.title}")
      end
      rply :msg_topten_page, page:songs.current_page, pages:songs.total_pages, out:out.join(", ")
    end
    
    def mostplayed
      page = argc == 1 ? 1 : argv[1]
      songs = RcbSong.order('playcount DESC').page(page).per(5)
      return rply :err_empty_page if songs.count == 0
      rank = (songs.current_page-1) * 5
      out = []
      songs.each do |song|
        rank += 1
        out.push("#{rank}.#{song.title}")
      end
      rply :msg_mostplayed_page, page:songs.current_page, pages:songs.total_pages, out:out.join(", ")
    end
    
  end
end