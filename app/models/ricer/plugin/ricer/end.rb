module Ricer::Plugin::Ricer
  class End < Ricer::Plug::Trigger
    
    def self.priority; 1; end

    def execute
      Begin.new(@irc_message).finish
    end
    
  end
end
