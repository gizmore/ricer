module Ricer::Plug
  class BaseExec < BaseArgs
    
    def self.triggered?(command); (command+' ').start_with?(trigger+' '); end

    protected
    
    def ricer_on(eventname)
      server.ricer_on(eventname, @irc_message)
    end
    
    ######################
    ### Fake exec pipe ###
    ######################
    def execu(user, line, authcheck=true)
      execcu(nil, user, line, authcheck)
    end
    def execc(channel, line, authcheck=true)
      execcu(channel, @irc_message.user, line, authcheck)
    end
    def execcu(channel, user, line, authcheck=true)
      tempu = @irc_message.user = user
      tempc = @irc_message.channel = channel
      exec(line, authcheck)
      @irc_message.user = tempu
      @irc_message.channel = tempc
    end
    def exec(line, authcheck=true)
      templine = @irc_message.args[1]
      @irc_message.args[1] = @irc_message.triggerchar+line
      process_trigger(authcheck, false)
      @irc_message.args[1] = templine
    end

    ##########################
    ### Trigger processing ###
    ##########################
    def process_trigger(authcheck=true, triggerevent=true)
      
      process_trigger_from(Ricer::Bot.instance.plugins, authcheck, triggerevent)
      
    end
    
    def process_trigger_from(plugins, authcheck=true, triggerevent=true)

      command = @irc_message.line
      if channel.nil?
        command = command[1..-1] if server.is_triggered? @irc_message.triggerchar
      else
        command = command[1..-1] if channel.is_triggered? @irc_message.triggerchar
      end
      
      last_known = nil
      plugins.each do |trigger|
        if trigger.triggered? command
          last_known = trigger
          if (!authcheck) || (trigger.in_scope?(channel) && trigger.permitted?(user, channel))
            return trigger.new(@irc_message).execute_wrapped(triggerevent)
          end
        end
      end

      if last_known.nil?
        unknown_command_error(command) 
      else
        scope_error(last_known) unless last_known.in_scope?(channel)
        permission_error(last_known) unless last_known.permitted?(user, channel)
      end
    end
    
    def unknown_command_error(command)
      ricer_on :unknown_command
    end
    
    def scope_error(trigger)
      return reply tt('ricer.plug.extender.works_in.err_only_private') if trigger.scope == :user
      return reply tt('ricer.plug.extender.works_in.err_only_channel') if trigger.scope == :channel
    end
    
    def permission_error(trigger)
      priv = trigger.privobject
      reply I18n.t 'ricer.plug.extender.needs_permission.err_permission', char:priv.priv, perm:priv.to_label
      return false 
    end
    
  end
end
