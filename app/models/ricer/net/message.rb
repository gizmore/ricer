module Ricer::Net
  class Message
    
    attr_reader :raw, :time

    attr_reader :prefix, :command, :argstart
    attr_accessor :server, :channel, :user, :args, :plugin_id, :triggered
    
    def initialize(rawmessage=nil)
      @time = Time.new
      @raw = rawmessage
    end
    
    def parse; stub('parse'); end
    def parsed; parse; self; end
    
    def user_id; user.id unless user.nil?; end
    def channel_id; channel.id unless channel.nil?; end
    
    def reply_target; channel != nil ? channel : user; end
    def reply_prefix; channel != nil ? "#{user.nickname}: " : ''; end
    def reply(text); send_privmsg(reply_target, text, reply_prefix); end
    def nreply(text); send_notice(user, text); end
    def reply_trigger; channel != nil ? channel.triggers[0] : server.triggers[0]; end
    
    def send_raw(text) self.server.send_raw text; end
    def send_notice(to, text, prefix=''); self.server.send_notice to, text, prefix; end
    def send_privmsg(to, text, prefix=''); self.server.send_privmsg to, text, prefix; end
    
    def line; @args[1] unless @args.nil?; end
    def triggerchar; line[0] unless line.nil?; end
    def argline; line.substr_from(' ') unless line.nil?; end
#    def argline; line; end
    def argv; argline.split(/ +/) unless argline.nil?; end
    def argc; a = argv; a == nil ? 0 : a.length; end

    def argsline; @argstart < 0 ? nil : @raw[@argstart..-1]; end
    
    def consolestring(input)
      sign = input ? '<<' : '>>'
      "#{server.domain} #{sign} #{@raw}"
    end

    protected
    def argstart=(argstart); @argstart = argstart; end
    def command=(command); @command = command; end
    def prefix=(prefix); @prefix = prefix; end

    private
    
    def stub(methodname)
      puts "OOOOPS!!!"
      throw "#{self.class.name} does not handle 'def #{methodname}'"
    end

  end
end
