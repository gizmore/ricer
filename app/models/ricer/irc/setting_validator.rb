module Ricer::Irc
  class SettingValidator
    
    def self.validate_definition!(classobject, name, hash)
      self.validate_setting_hash!(classobject, name, hash)
      self.validate_defaults!(classobject, name, hash)
    end
    
    private
    
    TYPES = [:boolean, :string, :enum, :pin, :password, :integer, :float, :date, :time, :duration]

    PIN_LEN = 8
    MAX_LEN = 192
    MAX_INT = 2147483647
    
    def self.validate_setting_hash!(classobject, name, hash)
      throw "Setting #{classobject.name} #{name} is missing a type" if hash[:type].nil?
      throw "Setting #{classobject.name} #{name} has an invalid type" unless TYPES.include?(hash[:type])
      throw "Setting #{classobject.name} #{name} is missing a scope" if hash[:scope].nil?
      self.validate_scope!(classobject, name, hash[:scope])
      throw "Setting #{classobject.name} #{name} is missing a permission" if hash[:permission].nil?
      self.validate_permission!(classobject, name, hash[:permission])
    end
    def self.validate_scope!(classobject, name, scope)
      Array(scope).each do |s|
        throw "Setting #{classobject.name} #{name} has an invalid scope" unless Ricer::Irc::Scope.valid?(s)
      end
    end
    def self.validate_permission!(classobject, name, permission)
      throw "Setting #{classobject.name} #{name} has an invalid permission" unless Ricer::Irc::Priviledge.valid?(permission)
    end

    ### Default overrides    
    def self.validate_defaults!(classobject, name, hash)
      self.send("validate_default_#{hash[:type]}!", classobject, name, hash)
      self.validate_default_value!(classobject, name, hash)
    end
    def self.validate_default_boolean!(classobject, name, hash)
      throw "Setting #{classobject.name} #{name} is missing boolean :default value" if hash[:default].nil?
    end
    def self.validate_default_string!(classobject, name, hash)
      hash[:min] = hash[:min]||0
      hash[:max] = hash[:max]||MAX_LEN
      hash[:min] = hash[:min].to_i
      hash[:max] = hash[:max].to_i
      throw "Setting #{classobject.name} #{name} has an invalid :min value" unless hash[:min].between?(0, MAX_LEN)
      throw "Setting #{classobject.name} #{name} has an invalid :max value" if hash[:max] < hash[:min]
    end
    def self.validate_default_enum!(classobject, name, hash)
      throw "Setting #{classobject.name} #{name} is an enum without :enums" if hash[:enums].nil? || hash[:enums].empty?
      throw "Setting #{classobject.name} #{name} is missing enum :default value" if hash[:default].nil?
    end
    def self.validate_default_pin!(classobject, name, hash)
      hash[:min] = hash[:min]||PIN_LEN
      hash[:max] = hash[:max]||PIN_LEN
      self.validate_default_string!(classobject, name, hash)
    end
    def self.validate_default_password!(classobject, name, hash)
      hash[:min] = hash[:min]||4
      hash[:max] = hash[:max]||MAX_LEN
      hash[:allow_nil] = hash[:allow_nil]||true
      self.validate_default_string!(classobject, name, hash)
    end
    def self.validate_default_integer!(classobject, name, hash)
      hash[:min] = hash[:min]||0
      hash[:max] = hash[:max]||MAX_INT
      hash[:min] = hash[:min].to_i
      hash[:max] = hash[:max].to_i
      hash[:default] = hash[:default]||hash[:min]
      self.validate_default_numeric(classobject, name, hash)
    end
    def self.validate_default_float!(classobject, name, hash)
      hash[:min] = hash[:min]||0
      hash[:max] = hash[:max]||MAX_INT
      hash[:min] = hash[:min].to_f
      hash[:max] = hash[:max].to_f
      hash[:default] = hash[:default]||hash[:min]
      self.validate_default_numeric(classobject, name, hash)
    end
    def self.validate_default_numeric(classobject, name, hash)
      throw "Setting #{classobject.name} #{name} out of bounds  :min value" unless hash[:min].between?(-MAX_INT, +MAX_INT)
      throw "Setting #{classobject.name} #{name} has an invalid :max value" if (hash[:max] < hash[:min]) || (hash[:max] > MAX_INT)
    end
    def self.validate_default_date!(classobject, name, hash)
    end
    def self.validate_default_time!(classobject, name, hash)
    end
    def self.validate_default_duration!(classobject, name, hash)
      hash[:max] = hash[:max]||2.years.to_f
      hash[:min] = hash[:min].to_f
      hash[:max] = hash[:max].to_f
      hash[:default] = hash[:default]||hash[:min]
      self.validate_default_numeric(classobject, name, hash)
    end
    
    def self.validate_default_value!(classobject, name, hash)
      setting = Setting.instanciate(name, hash)
      throw "Setting #{classobject.name} #{name} has an invalid :default value" unless setting.validate(setting.default)
    end
    
  end
end
 