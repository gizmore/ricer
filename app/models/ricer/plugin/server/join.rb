require 'uri'

module Ricer::Plugin::Server
  class Join < Ricer::Plug::Trigger
    def execute
      byebug
      server = Ricer::Irc::Server.search(argv[0]).first
      if server.nil?
        uri = URI(argv[0])
        return rply :err_uri_scheme if uri.scheme != 'irc' && uri.scheme != 'ircs'
        domain = uri.domain
        server = Ricer::Irc::Server.in_domain(uri.domain).first
      end
      
      puts server
      if server.nil?
        execute_add
      else
        execute_rejoin(server)
      end
    end
    
    def execute_add
      server = Ricer::Irc::Server.create({url:argv[0]})
      nick = Ricer::Irc::Nickname.create({server:server, nickname:'ricer'})
      server.instance_variable_set('@added_by', user)
      bot.servers.push(server)
      Ricer::Thread.new do |t|
        server.startup
      end
    end
    
    def execute_rejoin(server)
      server.send_quit(message) if server.connected?
      server.disconnect
    end
    
  end
end