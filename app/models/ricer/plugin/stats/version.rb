module Ricer::Plugin::Stats
  class Version < Ricer::Plug::Trigger
    
    has_setting :owner, type: :string, scope: :bot, permission: :responsible, :default => 'gizmore'
    
    def execute
      rply :version, owner:setting(:owner), version:bot.version, builddate:bot.builddate, ruby:RUBY_VERSION, os:os_signature, time:localtime
    end
    
    def os_signature
      puts RbConfig::CONFIG.inspect      
      'Linux'
    end
    
    def localtime
      I18n.l(Time.now)
    end
    
  end
end
