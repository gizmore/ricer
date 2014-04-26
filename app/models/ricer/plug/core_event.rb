module Ricer::Plug
  class CoreEvent < Event
    
    def self.priority; 1; end
    def self.is_core?; true; end
    
  end
end
