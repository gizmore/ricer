# Known ricer events
####
# ricer_on_trigger
# ricer_on_send
# ricer_on_receive
# ricer_on_logout
# ricer_on_register
# ricer_on_authenticate
####
module Ricer::Plug
  class Event < PlugBase

    def self.trigger; downcase_trigger; end
    
    def executable?; true; end
    def enabled?; true; end
        
    def event_enabled?(eventname)
      true
      #get_setting("#{eventname}_enabled", :boolean, [:channel, :server], true)
    end
  
    def process_event(eventname)
      begin
        send eventname
      rescue => e
        bot.log_exception(e)
      end
    end
    
    def self.sort_plugins(plugins, with_triggerlength=true)
      plugins.sort do |x,y|
        x.sortbits - y.sortbits 
      end
      plugins = plugins.sort do |x,y|
        x.priority - y.priority
      end
    end

  end
end
