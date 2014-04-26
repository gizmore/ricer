module Ricer::Plugin::Profile
  class Profile < Ricer::Plug::Trigger
    
    def self.upgrade_1; ProfileEntry.upgrade_1; end
    
    def execute
      
    end
    
  end
end