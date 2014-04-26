module Ricer::Plugin::Config
  class Conf < Ricer::Plug::Trigger
  
    def self.minargs; 1; end
    def self.maxargs; 3; end

    def execute; execute_configuration(:all); end

    def execute_configuration(config_scope)

      instance = instance_by_arg(argv[0])
      return rplyr :err_plugin if instance.nil?

      @config_scope = config_scope

      case argc
      when 1; show_vars(instance)
      when 2; show_var(instance, argv[1].to_sym)
      when 3; set_var(instance, argv[1].to_sym, argv[2])
      end
    end
    
    private
    
    def config_scope; @config_scope; end
    
    def config_settings(instance)
      back = {}
      instance.settings.each do |k,v|
        back[k] = v if Ricer::Irc::Scope.matching?(config_scope, v[:scope], channel)
      end
      back
    end
    
    def conflicting?(setting)
      count = 0
      setting.scopes.each do |scope|
        if Ricer::Irc::Scope.matching?(config_scope, scope, channel)
          count += 1
          setting.scope = scope
        end
      end
      count != 1
    end
    
    def change_permitted?(setting)
      user.privbits(channel) >= setting.priviledge.bit
    end

    
    def msg_no_trigger(instance)
      rply :msg_no_settings, :trigger => instance.class.trigger       
    end
    
    def show_vars(instance)
      s = config_settings(instance)
      return msg_no_trigger(instance) if s.empty?
      outvars = []
      s.each do |k,v|
        outvars.push(k)
      end
      rplyp :msg_overview, :trigger => instance.class.trigger, :vars => outvars.join(', ')
    end
    
    def show_var(instance, varname)
      return rplyp :err_no_such_var if config_settings(instance)[varname].nil?
      setting = instance.get_setting varname
      return rplyp :err_no_such_var if setting.nil?
      out = ''
      setting.scopes.each do |scope|
        if Ricer::Irc::Scope.matching?(config_scope, scope, channel)
          val = instance.get_setting(varname, scope)
          out += " #{Ricer::Irc::Scope.to_label(scope)}=#{val.show_value}"
        end
      end
      rplyp :msg_show_var, trigger:instance.class.trigger, varname:varname, values:out
    end

    def set_var(instance, varname, value)
      return rplyp :err_no_such_var if config_settings(instance)[varname].nil?
      setting = instance.get_setting varname
      return rplyp :err_no_such_var if setting.nil?

      return rplyp :err_conflicting if conflicting?(setting)
      return rplyp :err_permission unless change_permitted?(setting)
      return rplyp :err_invalid_value, trigger:instance.class.trigger, varname:varname, hint:setting.hint unless setting.validate(value)
      
      setting.id = instance.config_key(setting.name, setting.scope) if setting.id.nil?
      setting.value = setting.from_value(value)
      setting.save!

      return rplyp :msg_saved_setting, configscope:setting.scope, trigger:instance.class.trigger, varname:varname, value:setting.show_value
      
    end
    
  end

end
