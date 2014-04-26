module Ricer::Plugin::Mc
  class Sit < Ricer::Plug::Trigger
    
    is_subcommand

    scope_is :channel
    
    def execute
      
      place = argv(0)
      
      return rply :err_no_game unless Game.created_for?(channel)
      
      game = Game.for(channel)
      
      return rply :err_sitting if game.sitting?(user)
      
      return rply :err_taken if game.place_taken?(place)
      
      game.take_place(place)
      
      return rply :msg_take_place, taken:game.num_taken, max:game.max_seats, left:game.seats_left
      
    end
    
  end
end