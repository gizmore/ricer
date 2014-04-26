module Ricer::Plugin::Config
  class ConfUser < Ricer::Plug::Trigger

    trigger_is :confu

    def self.i18n_key
      ((Conf.name.gsub('::', '.')) + '.').downcase
    end

    def execute
      Conf.new(@irc_message).execute_configuration(:user)
    end

  end
end
