module Ricer::Plugin::Mc
  class Init < Ricer::Plug::Trigger
    
    is_subcommand
    scope_is :channel
    needs_permission :voice
    
    has_setting :kick,  type: :boolean, scope: :channel, permission: :voice, default: false 
    
    def execute
      
      return rply :err_running if Game.created_for?(channel)
      
      players = get_players
      
      #game = Game.init_mc(players)
      
      return rply :msg_created
      
    end
    
    private
    
    def get_players
      if argc == 1 && argv[0] == '!all'
        get_all_players
      else
        get_player_list(argline)
      end
    end
    
    def get_all_players
      channel.users
    end
    
    def get_player_list(line)
      
    end
    
  end
end