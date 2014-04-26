module Ricer::Plug::Extender::HasSetting
  
  def has_setting(name, options={})
    class_eval do |klass|
      
      Ricer::Irc::SettingValidator.validate_definition!(klass, name, options)
      
      s = klass.class_variable_defined?(:@@SETTINGS) ? klass.class_variable_get(:@@SETTINGS) : {}
      s[name] = options
      klass.class_variable_set(:@@SETTINGS, s)
      
    end
  end

end
