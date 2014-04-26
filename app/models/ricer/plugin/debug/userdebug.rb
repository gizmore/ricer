module Ricer::Plugin::Debug
  class Userdebug < Ricer::Plug::Trigger
    
    trigger_is :udbg
    scope_is :user
    
    def execute
      user = argc == 1 ? load_user(argv[0]) : self.user
      rplyr :err_user if user.nil?
      rply :msg_userinfo, {
        id: user.id,
        user: user.displayname,
        usermode: user.usermode.display,
        servpriv: user.display_permissions,
        hostmask: user.prefix,
        server: user.server.displayname,
      }
    end

  end
end
