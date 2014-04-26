module Ricer::Plugin::Admin
  class Raw < Ricer::Plug::Trigger

    needs_permission :responsible
    
    def execute
      server.send_raw(argline)
    end
    
  end
end
