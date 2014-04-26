module Ricer::Plugin::Auth
  class Login < Ricer::Plug::Trigger
  
    scope_is :user
    needs_permission :registered
    bruteforce_protected

    def execute
      return rply :err_already_authenticated if user.authenticated?
      return rply :err_wrong_password unless user.authenticate!(argv[0])
      rply :msg_authenticated
      ricer_on :authenticated
    end
  
  end
end
