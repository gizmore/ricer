module Ricer::Net
  class Connection
    
    attr_reader :server
    
    def initialize(server); @server = server;  end
    def connected?; @connected ? true : false; end
    def encrypted?; uri.sheme == 'ircs'; end
    def uri; URI(@server.url); end
    def hostname; uri.host; end
    def port; uri.port; end

    ##############
    ## Abstract ##
    ##############
    def connect; stub("connect"); end
    def disconnect; stub("disconnect"); end
    def get_line; stub("get_line"); end
    def send_raw(line); stub('send_raw'); end
    def send_pong(ping); stub('send_pong'); end
    def send_join(channelname); stub('send_join'); end
    def send_part(channelname); stub('send_part'); end
    def send_quit(quitmessage); stub('send_quit'); end
    def send_notice(to, text, prefix); stub('send_notice'); end
    def send_privmsg(to, text, prefix); stub('send_privmsg'); end
    def send_nick(nickname); stub('send_nick'); end
    def login(nickname); stub('login'); end
    def authenticate(nickname); stub('authenticate'); end

    ############
    ## Helper ##
    ############
    def get_message
      line = get_line
      puts "#{hostname} << #{line}"
      server.message_object(line.strip).parsed unless line.nil?
    end
 
    private
    def stub(methodname)
      throw "#{self.class.name} does not handle 'def #{methodname}'"
    end
    
  end
end
