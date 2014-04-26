module Ricer::Plug::Extender::RequiresRetype
  
  def requires_retype(options={always:true})
    
    class_eval do |klass|
      
      klass.extend_executable :retype if !!options[:always]

      protected

      def retype
        waitingfor = @@RETYPE[user]
        @@RETYPE.delete(user)
        return true if waitingfor == line
        @@RETYPE[user] = line
        rplyt 'ricer.plug.extender.requires_retype.msg_retype'
        return false
      end
      
      private

      @@RETYPE = {}

    end
      
  end

end
