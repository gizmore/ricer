module Ricer::Plug
  class FunTrigger < Trigger
    
    def self.init_min_max
      super()
      set_max_argc(255)
    end
    
  end
end
