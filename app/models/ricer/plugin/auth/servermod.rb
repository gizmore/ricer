module Ricer::Plugin::Auth
  class Servermod < Ricer::Plug::Trigger
  
    trigger_is :mods
  
    def execute
      case argc
      when 0
        show_mods(user)
      when 1
        show_mods(load_user(argv[0]))
      when 2
        change_mods(load_user(argv[0]), argv[1])
      end
    end
    
    private
    
    def show_mods(auser)
      return rplyr :err_user if auser.nil?
      bitstring = Ricer::Irc::Priviledge.display_bitstring(auser.permissions, auser.authenticated?)
      rply :msg_mods, 
        user:auser.displayname,
        bitstring:bitstring,
        server:auser.server.displayname
    end
    
    def change_mods(auser, perm)
      
      return rplyr :err_user if auser.nil?
      return rplyp :err_unregistered unless auser.registered?
      
      # Check priv argument
      newpriv = Ricer::Irc::Priviledge.by_arg(perm)
      return rplyp :err_permstring if newpriv.nil? || newpriv.unmodeable
      
      # Check permissions
      mypriv = user.privbits
      oldpriv = auser.permissions
      return rplyp :err_permission if (mypriv <= oldpriv) || (mypriv < newpriv.bit)

      # Change it      
      result = Ricer::Irc::Priviledge.change_via(perm[0], oldpriv, newpriv.bit*2-1)
      
      # No change
      return rplyp :msg_no_change if result[:change].empty?
      
      # Changed!
      auser.permissions = result[:bits]
      auser.save!
      return rply :msg_changed, user:auser.displayname, bitstring:result[:change], server:server.displayname
      
    end
  
  end
end
