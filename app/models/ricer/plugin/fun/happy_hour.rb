module Ricer::Plugin::Fun
  class HappyHour < Ricer::Plug::FunTrigger
    
    needs_permission :voice
    
    def execute
      reply 'https://www.youtube.com/watch?feature=player_detailpage&v=E0Mi1ANe79o#t=529s'
    end
    
  end
end
