module Ricer::Plugin::Debug
  class Dbtrace < Ricer::Plug::Trigger
    
    needs_permission :responsible
    
    def self.init
      ActiveRecord::Base.logger = nil
    end
    
    def execute
      if ActiveRecord::Base.logger.nil?
        ActiveRecord::Base.logger = Logger.new(STDOUT)
        rply :msg_on
      else
        ActiveRecord::Base.logger = nil
        rply :msg_off
      end    
    end

  end
end
