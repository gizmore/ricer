module Ricer::Plugin::Admin
  class Die < Ricer::Plug::Trigger

    requires_retype
    
    needs_permission :owner
    
    def execute
      message = argline||default_message
      bot.servers.each do |server|
        server.send_quit(message) if server.connected?
      end
      bot.running = false
    end
    
    private
    
    def default_message
      t(:default_message, :user => user.displayname)
    end
    
  end
end
