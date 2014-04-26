module Ricer::Net::Irc
  class Message < Ricer::Net::Message
    
    def parse
      
      raw = self.raw
      
      s = 0 # start index
      e = raw.index(' ') # end index
      l = false # Last processed?
      
      # Prefixes start with ':'
      if raw[s] == ':'
        self.prefix = raw[s..e-1]
      else
        e = -1
        self.prefix = nil
      end
      
      # Now the command
      s = e + 1
      e = raw.index(' ', s)
      if e.nil?
        # Which could be the last thing, without any args
        self.command = raw[s..-1].downcase
        self.argstart = -1
        return
      end
      self.command = raw[s..e-1]
      self.command = command.downcase
      self.argstart = e
      
      args = [];
      s = e + 1
      
      # match = /[^\s"']+|"([^"]*)"|'([^']*)'/.match(raw[s..-1])
      # puts match.inspect
      
      while !(e = raw.index(' ', s)).nil?
        if (raw[s] == ':')
          s = s + 1
          arg = raw[s..-1]
          s = raw.length
          l = true
        else
          arg = raw[s..e-1]
          s = e + 1
        end
        args.push(arg)
      end
      # Last arg
      if l == false
        s = s + 1 if raw[s] == ':'
        args.push(raw[s..-1])
      end
      self.args = args
    end
    
  end
end
