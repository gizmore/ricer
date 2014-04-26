module Ricer::Plugin::Quote
  class Show < Ricer::Plug::Trigger
    
    def execute
      
      arg = argline
      Quote.where(:id => arg).first
      
    end
    
  end
end