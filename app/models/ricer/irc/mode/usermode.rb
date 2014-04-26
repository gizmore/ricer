module Ricer::Irc::Mode
  class Usermode < Mode
    
    attr_reader :permissions
    
    @@usermodes = {
      generic: {
        bot: 'B',
        invisible: 'I',
        voice: 'v',
        halfop: 'h',
        operator: 'o',
        permbits: {
          '+' => :voice,
          '%' => :halfop,
          '@' => :operator,
        }
      }
    }
    def self.modes; @@usermodes; end
   
    def initialize
      super
      @permissions = 0;
    end
    
    def init_from_username(username)
      init_permissions(username.gsub(Regexp.new("[^#{Ricer::Irc::Priviledge.all_symbols}]"), ''))
    end
        
    def init_permissions(permissions)
      @permissions = 0;
      add_permissions(permissions)
    end

    def add_permissions(permissions)
      permissions.chars.each do |symbol|
        priv = Ricer::Irc::Priviledge.by_symbol(symbol)
        priv = Ricer::Irc::Priviledge.by_char(symbol) if priv.nil?
        if priv != nil
          result = Ricer::Irc::Priviledge.elevate(@permissions, priv.bit)
          @permissions = result[:bits]
        end
      end
    end
    
    def add_mode(mode)
      super(mode)
      self.add_permissions(mode)
    end

    def remove_mode(mode)
      super(mode)
      self.remove_permissions(mode)
    end

    def remove_permissions(permissions)
      permissions.chars.each do |symbol|
        priv = Ricer::Irc::Priviledge.by_symbol(symbol)
        priv = Ricer::Irc::Priviledge.by_char(symbol) if priv.nil?
        if priv != nil
          result = Ricer::Irc::Priviledge.lower(@permissions, priv.bit)
          @permissions = result[:bits]
        end
      end
    end
    
    def display_permissions
      Ricer::Irc::Priviledge.bitstring(@permissions)
    end
    
  end
end
