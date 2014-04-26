module Ricer::Plugin::Config
  class ConfBot < Ricer::Plug::Trigger
    
    trigger_is :confb
    
    def self.i18n_key
      ((Conf.name.gsub('::', '.')) + '.').downcase
    end

    def execute
      Conf.new(@irc_message).execute_configuration(:bot)
    end
    
  end
end
