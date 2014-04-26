module Ricer::Plugin::Test
  class Timer < Ricer::Plug::Trigger

    trigger_is :timertest
    
    def execute
      Ricer::Thread.new do |t|
        sleep 5
        rply :timeout
      end
    end
    
  end
end
