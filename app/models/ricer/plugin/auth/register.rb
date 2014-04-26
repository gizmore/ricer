module Ricer::Plugin::Auth
  class Register < Ricer::Plug::Trigger
  
    scope_is :user 
    bruteforce_protected
    
    def execute
      argc == 1 ? register : change_pass
    end
    
    private
    
    def register
      return rply :err_already_registered if user.registered?
      user.password = argv[0];
      user.save!
      user.login!
      rply :msg_registered
      ricer_on :registered
    end
    
    def change_pass
      return rply :err_wrong_pass unless user.authenticate(argv[1])
      user.password = argv[0];
      user.save!
      user.login!
      rply :msg_changed_pass
    end
  
  end
end
