module Ricer::Plug
  class TriggerBase < Event
    
    def self.trigger
      i18n_trigger
    end

    def enabled?
      setting :trigger_enabled
    end
    
    def execute_wrapped(triggerevent)
      begin
        if executable?
          @irc_message.plugin_id = self.class.plugin_id
          ricer_on(:trigger) if triggerevent
          execute
        end
      rescue ActiveRecord::RecordInvalid => e
        rplyr :err_record_invalid, :name => e.record.class.model_name.human , :message => e.record.errors.full_messages.join(', ')
      rescue => e
        reply_exception(e)
      end
    end
    
    protected
    def reply_exception(e)
      bot.log_exception(e)
      self.rplyt 'ricer.err_exception', :message => e.message, :location => reply_backtrace(e)
    end
    
    private
    def reply_backtrace(e)
      e.backtrace.each do |line|
        return line unless line.index('/models/ricer/').nil?
      end
      e.backtrace[0]
    end
    
  end
end
