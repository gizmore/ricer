module Ricer::Plugin::Rcb
  class Favs < Ricer::Plug::Trigger
    
    def execute
      page = argc == 0 ? '1' : argv[0]
      page.numeric? ? all(page) : search(page)
    end
    
    private
    
    def all(page)
      show_page(RcbSongFav.where(:user => user), page)
    end
    
    def search(term)
      page = argc == 1 ? '1' : argv[0]
      page = page.numeric? ? page.to_i : 1
      show_page(RcbSongFav.joins(:rcb_song).where(user:user).where("rcb_songs.title LIKE (?)", "%#{term}%"), page)
    end
    
    def show_page(relation, page)
      favs = relation.order('rcb_song_favs.level DESC, rcb_song_favs.updated_at DESC').page(page).per(5)
      return rply :err_empty_page if favs.count == 0
      out = []
      favs.each do |fav|
        out.push("#{fav.rcb_song.title}(#{fav.level})")
      end
      rply :msg_fav_page, page:favs.current_page, pages:favs.total_pages, out:out.join(', ')
    end
    
  end
end
