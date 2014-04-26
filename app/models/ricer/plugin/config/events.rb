module Ricer::Plugin::Config
  class Events < Ricer::Plug::Trigger
    
    trigger_is :events
    
    protected

    def help_plugins
      events = []
      Ricer::Bot.instance.plugins.each do |plugin|
        events.push(plugin) unless plugin < Ricer::Plug::Trigger
      end
      events
    end
 
  end

end
