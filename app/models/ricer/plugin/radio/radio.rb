module Ricer::Plugin::Radio
  class Radio < Ricer::Plug::Trigger
    
    def self.upgrade_1
      Model::AlbumSong.upgrade_1
      Model::Album.upgrade_1
      Model::Artist.upgrade_1
      Model::BandArtist.upgrade_1
      Model::Band.upgrade_1
      Model::Dj.upgrade_1
      Model::Genre.upgrade_1
      Model::Played.upgrade_1
      Model::Show.upgrade_1
      Model::SongGenre.upgrade_1
      Model::Song.upgrade_1
      Model::Station.upgrade_1
    end
    
    has_subcommand :playing
    
  end
end
