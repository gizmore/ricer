module Ricer::Plugin::Mc
  class Mc < Ricer::Plug::Trigger
    
    def self.upgrade_1
      Game.upgrade_1
      Player.upgrade_1
    end
    
    has_subcommand :init
    has_subcommand :sit
    
  end
end