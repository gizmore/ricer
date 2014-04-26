module Ricer::Plugin::Admin
  class Reboot < Ricer::Plug::Trigger
    
    requires_retype
    
    needs_permission :responsible
    
    def execute
      bot.reboot = true
      exec("die #{argline}")
    end

  end
end
