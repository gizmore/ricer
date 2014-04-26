###
### map different ircd servermodes on unified symbols
###
module Ricer::Irc::Mode
  class Servmode < Mode
    @@servermodes = {
      generic: {
        bot: 'B'
      },
      inspircd: {
        bot: 'b'
      },
      freenode: {
        bot: 'B'
      },
    }
    def self.modes; @@servermodes; end
  end
end
