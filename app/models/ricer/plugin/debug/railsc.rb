module Ricer::Plugin::Debug
  class Railsc < Ricer::Plug::Trigger
    
    needs_permission :responsible
    
    def execute
      reply eval(argline).inspect
    end

  end
end
