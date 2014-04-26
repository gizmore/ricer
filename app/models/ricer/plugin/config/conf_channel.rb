module Ricer::Plugin::Config
  class ConfChannel < Ricer::Plug::Trigger
    
    trigger_is :confc
    
    def self.i18n_key
      ((Conf.name.gsub('::', '.')) + '.').downcase
    end

    def execute
      Conf.new(@irc_message).execute_configuration(:channel)
    end

  end
end
