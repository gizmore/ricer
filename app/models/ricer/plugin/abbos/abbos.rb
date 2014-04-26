module Ricer::Plugin::Abbos
  class Abbos < Ricer::Plug::ListTrigger
    
    def self.upgrade_1;
      AbboItem.upgrade_1
      AbboTarget.upgrade_1
      Abbonement.upgrade_1
    end
    
    
  end
end