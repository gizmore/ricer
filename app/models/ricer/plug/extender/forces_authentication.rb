module Ricer::Plug::Extender::ForcesAuthentication
  def forces_authentication(options={always:true})
    
    class_eval do |klass|
      
      klass.extend_executable(:auth_check) if !!options[:always]
      
      protected
      
      def auth_check
        return auth_error if user.registered? && !user.authenticated? 
        return true
      end
      
      private
      
      def auth_error
        rply I18n.t('ricer.plug.extender.forces_authentication.err_not_authenticated')
        return false
      end

    end

  end
end
