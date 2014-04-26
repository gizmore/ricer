# Threadcount statistics
module Ricer
  class Thread < Thread
    @@peak = 1
    def self.peak; @@peak; end
    def self.count; list.length; end
      
    def initialize
      super
      now = Thread.list.length
      @@peak = now if now > @@peak
    end 
    
  end
end
