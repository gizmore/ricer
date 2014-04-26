module Ricer::Irc
  class Priviledge
    
    attr_reader :priv, :symbol, :char, :bit, :name, :modeable
    
    REGISTERED = 0x0001
    AUTHENTICATED = 0x0002
    RESPONSIBLE = 0x0400
    
    def unmodeable; !modeable; end

    def initialize(hash)
      @modeable = true
      hash.each { |name, value| instance_variable_set("@#{name}", value) }
    end

    def self.not_authenticated(bits)
      bits & REGISTERED
    end
    
    @@all =
      {
        public:        new(priv:'p', symbol:'',  char:'',  bit:0x0000, :name => :public, :modeable => false),
        registered:    new(priv:'r', symbol:'',  char:'',  bit:0x0001, :name => :registered, :modeable => false),
        authenticated: new(priv:'l', symbol:'',  char:'',  bit:0x0002, :name => :authenticated, :modeable => false),
        voice:         new(priv:'v', symbol:'+', char:'v', bit:0x0004, :name => :voice),
        halfop:        new(priv:'h', symbol:'%', char:'h', bit:0x0008, :name => :halfop),
        operator:      new(priv:'o', symbol:'@', char:'o', bit:0x0010, :name => :operator),
        staff:         new(priv:'s', symbol:'',  char:'',  bit:0x0020, :name => :staff),
        admin:         new(priv:'a', symbol:'',  char:'',  bit:0x0040, :name => :admin),
        founder:       new(priv:'f', symbol:'',  char:'',  bit:0x0080, :name => :founder),
        ircop:         new(priv:'i', symbol:'',  char:'',  bit:0x0100, :name => :ircop),
        owner:         new(priv:'x', symbol:'',  char:'',  bit:0x0200, :name => :owner),
        responsible:   new(priv:'y', symbol:'',  char:'',  bit:0x0400, :name => :responsible, :modeable => false),
      }
      
    def to_s
      "Ricer::Irc::Priviledge(#{priv})"
    end
    
    def bits
      back = 0
      abit = bit
      while abit > 0
        back |= abit
        abit >>= 1 
      end
      back
    end
    
    def self.all_symbols
      back = ''
      @@all.each do |k,p|
        back += p.symbol
      end
      back
    end
    def self.all_chars
      back = ''
      @@all.each do |k,p|
        back += p.char
      end
      back
    end
    
    def self.valid?(name)
      self.by_name(name) != nil
    end
    
    def self.by_name(name)
      @@all[name]
    end
    
    def self.by_priv(priv)
      @@all.each do |k,v|
        return v if v.priv == priv
      end
      return nil
    end
    
    def self.by_bit(bit)
      @@all.each do |k,v|
        return v if v.bit == bit
      end
      return nil
    end
    
    def self.by_symbol(symbol)
      @@all.each do |k,v|
        return v if v.symbol == symbol
      end
      return nil
    end

    def self.by_char(char)
      @@all.each do |k,v|
        return v if v.char == char
      end
      return nil
    end
    
    def self.by_arg(arg)
      return nil unless ['+','-'].include?(arg[0])
      p = self.by_priv(arg[1..-1])
      p = self.by_name(arg[1..-1]) if p.nil?
      return self.by_bit(p.bit >> 1) if arg[0] == '-' && p.bit > 0
      return p
    end
    
    def to_label
      return I18n.t('ricer.irc.priviledge.'+self.priv)
    end
    
    def self.to_label(name)
      self.by_name(name).to_label
    end
    
    
    def self.bitstring(bits)
      back = ''
      @@all.each do |k,p|
        if (p.bit & bits) == p.bit
          back += p.priv
        end
      end
      back
    end
    
    def self.display_bitstring(bits, authenticated)
      s = self.bitstring(bits)
      s = "\x02prl\x02#{s[3..-1]}" if s.length >= 3 && !authenticated
      s = "\x02#{s}\x02" if authenticated
      return s
    end
    
    def self.change_via(mode, from, to)
      case mode
      when '+'
        return self.elevate(from, to)
      when '-'
        return self.lower(from, to)
      end
      return {bits:from, change:''}
    end
    
    def self.elevate(from, to)
      return change(from, to) unless from >= to
      return {bits:from, change:''}
    end

    def self.lower(from, to)
      return change(from, to) unless from <= to
      return {bits:from, change:''}
    end
    
    # Change bits and return which bits have changed
    def self.change(from, to)
      bits = 0
      change = from > to ? '-' : '+'
      @@all.each do |k,p|
        if to >= p.bit
          if from < p.bit
            change += p.priv
          end
          bits |= p.bit
        elsif from >= p.bit
          change += p.priv
        end
      end
      return {bits:bits, change:change}
    end

  end 
end
