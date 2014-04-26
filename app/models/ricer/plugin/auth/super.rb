module Ricer::Plugin::Auth
  class Super < Ricer::Plug::Trigger
    
    scope_is :user
    needs_permission :authenticated
    bruteforce_protected
    
    has_setting :password,  scope: :server, permission: :responsible, type: :password
    has_setting :superword, scope: :bot,    permission: :responsible, type: :password, default: 'hellricer'
    has_setting :magicword, scope: :bot,    permission: :responsible, type: :password, default: 'chickencurry'
    
    def execute
      pass = argv[0]
      return elevate(:admin) if get_setting(:password).password_match?(pass)
      return elevate(:owner) if get_setting(:superword).password_match?(pass)
      return elevate(:responsible) if get_setting(:magicword).password_match?(pass)
      rply :err_password
    end
    
    private
    
    def elevate(permission)
      
      permission = Ricer::Irc::Priviledge.by_name(permission)
      
      result = Ricer::Irc::Priviledge.elevate(user.permissions, permission.bit)

      user.flush_chanperms
      user.chanperms.all.each do |cp|
        cp.permissions = result[:bits]
        cp.save!
      end

      user.permissions = result[:bits]
      user.save!
      
      rply :msg_elevated, :change => permission.to_label

    end
  
  end
end
