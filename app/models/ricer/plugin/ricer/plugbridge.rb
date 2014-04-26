module Ricer::Plugin::Ricer
  class Plugbridge < Ricer::Plug::CoreEvent
    
    def on_notice
      # Every privmsg origins from a user
      @irc_message.user = create_user()
      # And maybe belongs to a channel
      @irc_message.channel = server.get_channel(@irc_message.args[0])
    end
    
    def on_privmsg
      # Every privmsg origins from a user
      @irc_message.user = create_user()
      
      # PRIVMSG always goto channel... unless it´s a query :)
      # So when loading channel from memory fails it´s a query :)
      @irc_message.channel = channel = server.get_channel(@irc_message.args[0])
      
      # Check if we got a triggered
      if channel.nil?
        triggered = true
        @irc_message.triggered = server.is_triggered?(@irc_message.triggerchar)
      else
        triggered = @irc_message.triggered = true if (channel != nil) && (channel.is_triggered?(@irc_message.triggerchar))
      end
      
      process_trigger if triggered && !flooding?(@irc_message.user)
    end
    
    private
    
    def flooding?(user)
      last = user.instance_variable_defined?(:@last_msg_time) ? user.instance_variable_get(:@last_msg_time) : 0.0
      now = Time.now.to_f
      elapsed = now - last
      if elapsed <= server.cooldown
        puts "FLOODING!!!"
        return true
      else
        user.instance_variable_set(:@last_msg_time, now)
        return false
      end
    end
    
  end
end
