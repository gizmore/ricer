module Ricer::Plugin::Config
  class ConfServer < Ricer::Plug::Trigger
    
    trigger_is :confs
    
    def self.i18n_key
      ((Conf.name.gsub('::', '.')) + '.').downcase
    end

    def execute
      Conf.new(@irc_message).execute_configuration(:server)
    end
    
  end
end
