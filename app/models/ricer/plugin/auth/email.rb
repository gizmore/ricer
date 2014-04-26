module Ricer::Plugin::Auth
  class Email < Ricer::Plug::Trigger
  
    def self.revision; 2; end
    def self.upgrade_1; EmailConfirmation.upgrade_1; end
    def self.upgrade_2; EmailConfirmation.upgrade_2; end

    needs_permission :authenticated
    
    has_setting :valid_for, type: :duration, scope: :bot, permission: :responsible, default: 4.hours
    
    def execute
      EmailConfirmation.cleanup
      case argc
      when 0; show
      when 1; request(argv[0])
      when 2; confirm(argv[0], argv[1])
      end
    end
    
    private
    
    def show
      return rply :msg_none if user.email.nil?
      rply :msg_show, email:user.email
    end
    
    def request(address)
      EmailConfirmation.delete_all(:user => user)
      confirmation = EmailConfirmation.new_confirmation(user, address, setting(:valid_for))
      return rply :err_address unless confirmation.valid?
      confirmation.save!
      send_mail(confirmation)
      nrply :msg_sent, email:address, duration:display_valid_for
    end
    
    def send_mail(confirmation)
      to = confirmation.email
      body = t(:mail_body, user:user.nickname, code:confirmation.code, email:to)
      generic_mail(to, t(:mail_subj), body)
    end
    
    def display_valid_for
      lib.human_duration get_setting(:valid_for).show_value
    end
    
    def confirm(address, code)
      confirmation = EmailConfirmation.where(user:user, email:address, code:code).first
      return rply :err_code if confirmation.nil?
      user.email = confirmation.email
      user.save!
      confirmation.delete
      return rply :msg_set, email:user.email
    end
    
  end
end
