module Ricer::Plug::Extender::MaxCharacters
  def max_characters(num)
    class_eval do |klass|
      
      klass.class_variable_set(:@@MAX_CHARACTERS, num.to_i)

    end
  end
end
