module Ricer::Plug
  class BaseSettings < BaseExec
    
    def settings; self.class.class_variable_get(:@@SETTINGS); end
    def self.default_enabled?; true; end
    def self.default_settings
      { trigger_enabled: { type: :boolean, default: default_enabled?, permission: :responsible, scope:[:channel,:server] } }
    end

    def self.permission; class_variable_get('@@PERMISSION'); end
    def self.privobject; Ricer::Irc::Priviledge.by_name(permission); end
    def self.privbits; privobject.bit; end
    
    def self.scope; self.class_variable_get('@@SCOPE'); end
    def self.scopeobject; Ricer::Irc::Scope.by_name(self.scope); end
    def self.scopebits; self.scopeobject.bit; end
    
    def self.sortbits; self.privbits | self.scopebits; end
    
    def self.in_scope?(channel)
      bit = channel != nil ? Ricer::Irc::Scope::CHANNEL_SCOPE : Ricer::Irc::Scope::USER_SCOPE
      (bit & self.scopebits) > 0
    end
    
    def self.permitted?(user, channel)
      user.privbits(channel) >= privbits
    end
    
    def config_key(name, scope)
      #puts "BaseSettings.config_key(#{name}, #{scope})"
      pid = plugin_id.to_s
      name = name.to_s
      return pid+':B:'+name if scope == :bot
      return pid+':C:'+channel.id.to_s+':'+name if (channel != nil) && (scope == :channel)
      return pid+':S:'+server.id.to_s+':'+name if scope == :server
      return pid+':U:'+user.id.to_s+':'+name if scope == :user
    end

    def setting(name, scope=nil, value=nil, default=nil)#, type=nil)
      setting_do(get_setting(name, scope), value, default)
    end
    
    def setting_do(setting, value=nil, default=nil)
      value == nil ?
        setting_value(setting, default) :
        save_setting(setting, value)
    end

    def get_setting(name, scope=nil)
      hash = settings[name]
      Array(scope||hash[:scope]).each do |sc|
        setting = get_setting_db(name, sc, hash)
        return setting unless setting.nil?
      end
      Ricer::Irc::Setting.instanciate(name, hash, scope)
    end
    
    def get_setting_db(name, scope, hash)
      key = config_key(name, scope)
      return nil if key.nil?
      setting = Ricer::Irc::Setting.where(id:key).first
      return nil if setting.nil?
      setting.name = name; setting.hash = hash; setting.scope = scope
      return setting
    end
   
    def server_setting(server, name, value=nil, default=nil)
      foreign_setting(server, user, channel, name, :server, value, default)
    end
    def user_setting(user, name, value=nil, default=nil)
      foreign_setting(server, user, channel, name, :user, value, default)
    end
    def channel_setting(channel, name, value=nil, default=nil)
      foreign_setting(server, user, channel, name, :channel, value, default)
    end

    def foreign_setting(server, user, channel, name, scope, value=nil, default=nil)
      setting = foreign_get_setting(server, user, channel, name, scope)
      setting_do(setting, value, default)
    end
    
    def server_get_setting(server, name)
      foreign_get_setting(server, user, channel, name, :server)
    end
    def user_get_setting(user, name)
      foreign_get_setting(server, user, channel, name, :user)
    end
    def channel_get_setting(channel, name)
      foreign_get_setting(server, user, channel, name, :channel)
    end
    
    def foreign_get_setting(server, user, channel, name, scope)
      t_serv = @irc_message.server; tusr = @irc_message.user; t_chann = @irc_message.channel
      @irc_message.server = server; @irc_message.user = user; @irc_message.channel = channel
      back = get_setting(name, scope)
      @irc_message.server = t_serv; @irc_message.user = tusr; @irc_message.channel = t_chann
      back
    end
      
    protected
    
    def setting_value(setting, scope=nil, default=nil)
      setting.to_value(default)
    end
    
    def save_setting(setting, value)
      varkey = config_key(setting.name, setting.scope)
      value = setting.from_value(value) unless value.nil?
      s = Ricer::Irc::Setting.where(id:varkey).first
      if s.nil?
        s = Ricer::Irc::Setting.create!({id:varkey, value:value}) unless value.nil?
      elsif value.nil?
        s.destroy!
      else
        s.value = value
        s.save!
      end
      value == nil ? nil : setting.to_value(value)
    end
    
  end
end
