module Ricer::Plugin::Quote
  class List < Ricer::Plug::Trigger
    
    def self.upgrade_1; Quote.upgrade_1; end
    
    def execute
      latest = Quote.order('created_at DESC').first
      rply :msg_stats, count:Quote.count 
      exec 'quote '
    end
    
  end
end
