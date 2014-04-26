module Ricer::Plug::Extender::TriggerIs
  def trigger_is(trigger)
    class_eval do |klass|
      klass.class_variable_set(:@@TRIGGER, trigger.to_s)
    end      
  end
end
