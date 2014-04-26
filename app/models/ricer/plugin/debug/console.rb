module Ricer::Plugin::Debug
  class Console < Ricer::Plug::Trigger
    
    needs_permission :responsible
    
    def execute
      eval(argline)
    end

  end
end
