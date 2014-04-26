module Ricer::Plug::Extender::BruteforceProtected
  def bruteforce_protected(options={always:true})

    has_setting :timeout, scope:[:channel,:server], permission: :admin, type: :duration, default: 7.seconds

    class_eval do |klass|

      klass.extend_executable(:not_bruteforcing?) if !!options[:always]
      
      protected
      
      def timeout; setting(:timeout); end
      
      def not_bruteforcing?
        !bruteforcing?
      end

      def bruteforcing?
        clear_tries
        if @@BF_TRIES[user].nil?
          register_attempt
          return false
        end
        error_bruteforce
        return true
      end
      
      private

      @@BF_TRIES = {}

      def display_timeout;
        lib.human_duration(timeout_seconds);
      end
      
      def timeout_seconds
        @@BF_TRIES[user] - Time.now.to_f
      end
      
      def error_bruteforce
        reply I18n.t('ricer.plug.extender.bruteforce_protected.err_bruteforce', timeout:display_timeout)
      end
      
      def register_attempt
        @@BF_TRIES[user] = Time.now.to_f + timeout
      end
      
      def clear_tries
        @@BF_TRIES.each do |k,v|
          @@BF_TRIES.delete(k) if v < Time.now.to_f
        end
      end
      
    end
  end
end
