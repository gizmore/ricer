module Ricer::Irc::Mode
  class Mode

    attr_reader :modestring
    
    def initialize
      @modestring = ''
    end
    
    def display
      @modestring.to_s
    end
    
    @@SIGNATURE = nil
    @@SERVERTYPE = :generic
    
    EXPRESSIONS = {
      inspirc: /inspircd/i,
      generic: //
    }
    
    def self.init_signature(signature)
      @@SIGNATURE = signature
      @@SERVERTYPE = servertype(signature)
      Ricer::Bot.instance.log_info("Parsing server signature: #{signature} => #{@@SERVERTYPE})")
    end
    
    def self.servertype(signature)
      EXPRESSIONS.each do |type, pattern|
        return type if pattern.match(signature)
      end
    end
    
    def self.features?(mode)
      self.to_char(mode) != nil
    end
    
    def self.knows?(char)
      self.compiledmodes.each do |k,v|
        return true if v == char
      end
      return false
    end
    
    def has_mode?(mode)
      @modestring.index(mode) != nil
    end
    
    def add_mode(modes)
      modes.chars.each do |mode|
        @modestring += mode unless has_mode?(mode)
      end
    end

    def remove_mode(modes)
      @modestring = @modestring.gsub(Regexp.new("[#{modes}]"), '')
    end
    
    private
    
    def to_char(mode)
      self.class.to_char(mode);
    end
    
    def self.to_char(mode)
      compiledmodes[mode]
    end

    def self.compiledmodes
      back = modes[:generic]
      back = back.merge(modes[@@SERVERTYPE]) unless @@SERVERTYPE == :generic || modes[@@SERVERTYPE].nil?
      back
    end
    
  end
end