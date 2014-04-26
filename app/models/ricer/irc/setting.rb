require 'bcrypt'
module Ricer::Irc
  class Setting < ActiveRecord::Base
    
   # belongs_to :plugin,  :condition =>  'settings.id LIKE CONCAT(plugins.id, ":%")'
    
    attr_accessor :name, :hash, :scope
    
    def min; hash[:min]; end
    def max; hash[:max]; end
    def type; hash[:type]; end
    def enums; hash[:enums]; end
    def default; hash[:default]; end
    def allow_nil; !!hash[:allow_nil]; end
    def precision; hash[:precision]||2; end
    def scopes; Array(hash[:scope]); end
    def permission; hash[:permission]; end;
    def displaytype; self.class.displaytype(type); end
    def priviledge; Priviledge.by_name(permission); end
    def self.displaytype(type);  I18n.t("ricer.irc.setting.type.#{type}"); end
    def self.instanciate(name, hash, scope=nil)
      obj = self.new
      obj.name = name
      obj.hash = hash
      obj.scope = scope
      obj.value = obj.from_value(hash[:default])
      return obj
    end
    
    def save_as(config_key)
      id = config_key
      save!
    end
    
    def self.random_pin
      'p1nn-num8'      
    end
    
    ###################
    ### Value Types ###
    ###################
    
    def hint(input=nil); typesend 'hints', input; end
    def to_value(input=nil); typesend 'to', input; end
    def from_value(input=nil); typesend 'from', input; end
    def show_value(input=nil); typesend 'show', input; end
    def validate(input=nil); input == nil ? allow_nil : typesend('valid', input); end
    
    def pin_match?(pin); from_pin(pin) == to_pin(value); end
    def password_match?(password); value == nil ? false : BCrypt::Password.new(value).is_password?(password); end

    private
    
    def typesend(func, input); send("#{func}_#{type}", input == nil ? value : input); end
    
    ##################################
    ### Value Type Implementations ###
    ##################################
    def display_no; display_bool('0'); end
    def display_yes; display_bool('1'); end
    def display_bool(digit); I18n.t('ricer.irc.setting.boolean_'+digit); end
    def hints_boolean(value); "#{display_no}|#{display_yes}"; end
    def to_boolean(value); value == '1'; end
    def from_boolean(value)
      return '1' if (value == true) || (value == '1')
      return '0' if (value == false)
      ['on', 'yes', display_yes].include?(value.downcase) ? '1' : '0'
    end
    def show_boolean(value); display_bool(from_boolean(value)); end
    def valid_boolean(value); from_boolean(value) != nil; end

    ## String
    def hints_string(value); I18n.t('ricer.irc.setting.hint.strlen', min:min, max:max); end
    def to_string(value); value.to_s; end
    def from_string(value); value.to_s; end
    def show_string(value); "'#{value}'"; end
    def valid_string(value); value.length.between?(min, max); end
    
    ## Enum
    def hints_enum(value); enums.map{|e|":{#{e}}"}.join(''); end
    def to_enum(value); value.to_sym; end
    def from_enum(value); value.to_s; end
    def show_enum(value); ":#{value}"; end
    def valid_enum(value); enums.include?(value.to_sym); end
    
    ## Pin
    def hints_pin; I18n.t('ricer.irc.setting.hint.pin', length:PIN_LEN); end
    def to_pin(value); value.to_s; end
    def from_pin(value); value.to_s.gsub('-', ''); end
    def show_pin(value); "'#{value[0..3]}-#{value[4..7]}'"; end
    def random_pin(); self.class.random_pin; end;
    def valid_pin(value); /[a-z0-9]{4}-?[a-z0-9]{4}/.match(value); end
  
    def hints_password; I18n.t('ricer.irc.setting.hint.password', min:min); end
    def to_password(value); value.to_s; end
    def from_password(value); value == nil ? nil : BCrypt::Password.create(value); end
    def show_password(value); "$:1:BCRYPT:HASH:$"; end
    def valid_password(value); valid_string(value); end
    
    def hints_intger(value); I18n.t('ricer.irc.setting.hint.integer', min:min, max:max); end
    def to_integer(value); value.to_i; end
    def from_integer(value); value.to_i.to_s; end
    def show_integer(value); value.to_i.to_s; end
    def valid_integer(value); /^[+-]?[0-9]{0,10}$/.match(value.to_s) && value.to_i.between?(min, max); end
    
    def hints_float(value); I18n.t('ricer.irc.setting.hint.float', min:min, max:max); end
    def to_float(value); value.to_f; end
    def from_float(value); show_float value; end
    def show_float(value); number_with_precision value.to_f, precision:precision; end
    def valid_float(hash, value); /^[-+]?[0-9]{0,10}\.?[0-9]{0,9}$/.match(value.to_s) && value.to_f.between?(min, max); end


    def hints_time(value); '' end;
    def to_time(value); Time.new(value); end
    def from_time(value); Chronic.parse(value).to_s; end
    def show_time(value); I18n.l(to_time(from_time(value))); end
    def valid_time(value); Chronic.parse(value) != nil; end
    
    
    def hints_date(value); '' end;
    def to_date(value); DateTime.new(value); end
    def from_date(value); chronic.parse(value).to_s; end
    def show_date(value); I18n.l(to_date(from_date(value))); end
    def valid_date(value); Chronic.parse(value) != nil; end


    def hints_duration(value); '' end;
    def to_duration(value); value.to_f; end
    def from_duration(value); value.to_s; end
    def show_duration(value); Lib.instance.human_duration(to_duration(from_duration(value))); end
    def valid_duration(value); begin; to_duration(from_duration(value)).between?(min, max); rescue => e; false; end; end

  end
end
