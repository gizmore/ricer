module Ricer::Plug

  class Base
    
    def bot; Ricer::Bot.instance; end;
    def self.bot; Ricer::Bot.instance; end
  
    def self.classname; name.split('::')[3]; end
    def self.modulename; name.split('::')[2]; end

    def self.revision; 1; end
    def self.version; 1.0; end
    def self.author; "gizmore@wechall.net"; end
    def self.date; "14.Feb.2014"; end; # Please stick to nN.Mon.Year
    def self.priority; 50; end
    
    def self.environments; [:development, :test, :production]; end
    def self.env_enabled?; environments.include?(Rails.env.to_sym); end
    
    def self.init; end
    def self.install; end
    def self.upgrade_1; end;

    def self.validate!; end
    
    def self.classobject()
      Object.const_get('Ricer').const_get('Plugin').const_get(self.modulename).const_get(self.classname)
    end

    def classobject_by_arg(arg, auth_check=true)
      classobject_by_trigger(arg, auth_check) || classobject_by_path(arg, auth_check)
    end
    
    def instance_by_arg(arg, auth_check=true)
      classobject = classobject_by_arg(arg, auth_check)
      classobject.new(@irc_message) unless classobject.nil?
    end
    
    protected
    
    def classobject_by_trigger(arg, auth_check=true)
      Ricer::Bot.instance.plugins.each do |plugin|
        if plugin.triggered?(arg)
          return plugin if (plugin.in_scope?(channel) && (!auth_check || plugin.permitted?(user, channel)))
        end
      end
      return nil;
    end

    def classobject_by_path(path, auth_check=true)
#      path = path.split('/')
#      Object.const_get('Ricer').const_get('Plugin').const_get(path[0].classify).const_get(path[1].classify)
    end
    
  end
end
