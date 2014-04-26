module Ricer::Plugin::Debug
  class Userdebugc < Ricer::Plug::Trigger
    
    trigger_is :udbg
    scope_is :channel
    
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
        channel: channel.displayname,
        chanmode: user.chanperms_for(channel).usermode.display,
        chanpriv: user.chanperms_for(channel).display_permissions,
      }
    end

  end
end
