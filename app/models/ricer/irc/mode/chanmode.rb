module Ricer::Irc::Mode
  class Chanmode < Mode
    
    @@channelmodes = {
      generic: {
        muted: 'm'
      }
    }
    def self.modes; @@channelmodes; end
    
  end
end
