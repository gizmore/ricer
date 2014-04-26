module Ricer::Plugin::Cvs
  class Add < Ricer::Plug::Trigger
    
    is_subcommand
    
    has_setting :default_public, type: :boolean, scope: :bot,             permission: :responsible, default:false
    has_setting :default_delay,  type: :integer, scope: [:channel,:user], permission: :operator,    default:60, min:3, max:240
    
    needs_permission :voice
    
    def execute
      return rply :err_dup_name unless Repo.by_name(argv[0]).nil?
      return rply :err_dup_url unless Repo.by_url(argv[0]).nil?
      repo = Repo.new({
        user: user,
        name: argv[0],
        url: argv[1],
        public: argv[2] == nil ? setting(:default_public) : argv[2],
        pubkey: argv[3],
      })
      repo.validate!
      Ricer::Thread.new do |t|
        begin
          system = System.new(repo, self, setting(:default_delay))
          system_name = system.detect
          return rply :err_system if system_name.nil?
          system = System.get_system(system_name).new(repo, self, setting(:default_delay))
          return rply :err_system if system.nil?
          repo.system = system_name
          repo.revision = system.revision
          repo.save!
          rply :msg_repo_added, name:repo.name, url:repo.url, type:repo.system
        rescue => e
          reply_exception e
        end
      end
    end
    
  end
end
