module Ricer::Plug::Extender::NeedsPermission
  def needs_permission(permission=:public)
    class_eval do |klass|
      
      # Check sanity
      throw "Invalid permission '#{permission}' for '#{klass.name}' for extender: 'NeedsPermission'." if Ricer::Irc::Priviledge.by_name(permission).nil?
      
      klass.class_variable_set('@@PERMISSION', permission)
      
      protected
      
      def has_permission?(permission)
        return true if permission == :public
        has_permissions_in?(permission, channel)
      end
      
      def has_permissions_in?(channel, permission)
        priv = Ricer::Irc::Priviledge.by_name(permission)
        return true if user.privbits(channel) >= priv.bit
        permission_error(self.class)
      end
      
    end
  end
end
