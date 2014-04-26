module Ricer::Plug::Extender::RequiresConfirmation
  def requires_confirmation(options={random:false,always:true})
    class_eval do |klass|
      
      klass.class_variable_set(:@@REQUIRES_RANDOM_WORD, !!options[:random])
      
      klass.extend_executable :confirm if !!options[:always]
      
      protected
      
      def confirm
        waitingfor = @@CONFIRM[user]
        @@CONFIRM.delete(user)
        return true if waitingfor == line
        @@CONFIRM[user] = line + ' ' + confirmationword
        rplyt 'ricer.plug.extender.requires_confirmation.msg_confirm', phrase:@@RETYPE[user]
        return false
      end
      
      private
      
      @@CONFIRM = {}

      def confirmationword
        word = self.class.class_variable_get(:@@REQUIRES_RANDOM_WORD) ?
          SecureRandom.base64(3) :
          I18n.t('ricer.plug.extender.confirm.word')
      end
      
    end
  end
end
