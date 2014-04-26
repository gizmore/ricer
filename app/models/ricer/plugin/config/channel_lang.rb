module Ricer::Plugin::Config
  class ChannelLang < Ricer::Plug::Trigger
    
    trigger_is :clang
    
    def execute
      argc == 0 ? show : set
    end
    
    private
    
    def show
      rply :msg_show, :iso => channel.locale.to_label, :available => UserLang.available
    end
    
    def set
      have = channel.locale
      want = Ricer::Locale.by_iso(argv[0])
      return rplyr :err_lang_iso if want.nil?
      channel.locale = want
      channel.save!
      rply :msg_set, :old => have.to_label, :new => want.to_label
    end

  end
end
