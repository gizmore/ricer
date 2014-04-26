module Ricer
  class Locale < ActiveRecord::Base
    
    def self.valid?(iso)
      exists?(iso)
    end

    def self.exists?(iso)
      where(:iso => iso).count > 0
    end
    
    def self.by_iso(iso)
      where(:iso => iso).first
    end
    
    def to_label
      I18n.t("ricer.lang_iso.#{iso}")
    end

  end
end