module Ricer::Plug
  class Trigger < TriggerBase

    def execute
      rplyr :err_stub_trigger
    end

    def executable?
      return error_help if error_argc
      return error_disabled unless enabled?
      self.class.has_executable_extenders? ? executable_extenders? : true
    end
    
    def self.extend_executable(methodname)
      ext = has_executable_extenders? ? executable_extenders : []
      ext.push(methodname.to_sym)
      set_executable_extenders(ext)
    end
    
    private

    def executable_extenders?
      self.class.executable_extenders.each do |exec|
        return false unless self.send exec
      end
      return true
    end

    def self.has_executable_extenders?; class_variable_defined?(:@@EXECUTABLE_EXTENDERS); end
    def self.executable_extenders; class_variable_get(:@@EXECUTABLE_EXTENDERS); end
    def self.set_executable_extenders(extenders); class_variable_set(:@@EXECUTABLE_EXTENDERS, extenders); end

    def error_help; show_help; false; end
    def error_argc; !argc.between?(self.class.minargs, self.class.maxargs); end
    def error_disabled; rplyr :err_disabled; end

  end
end
