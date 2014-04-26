module Ricer::Plugin::Config
  class UserLang < Ricer::Plug::Trigger
    
    trigger_is :lang
    
    def self.available
      out = []
      Ricer::Locale.all.each do |l|
        out.push(l.iso)
      end
      out.join(', ')
    end
    
    def execute
      argc == 0 ? show : set
    end
    
    private
    
    def show
      rply :msg_show, :iso => user.locale.to_label, :available => self.class.available
    end
    
    def set
      have = user.locale
      want = Ricer::Locale.by_iso(argv[0])
      return rplyr :err_lang_iso if want.nil?
      user.locale = want
      user.save!
      rply :msg_set, :old => have.to_label, :new => want.to_label
    end

  end
end
