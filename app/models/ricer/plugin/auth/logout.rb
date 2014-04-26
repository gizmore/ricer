module Ricer::Plugin::Auth
  class Logout < Ricer::Plug::Trigger
  
    needs_permission :authenticated

    def execute
      user.logout!
      ricer_on :logout
      return rply :msg_logged_out
    end
  
  end
end
