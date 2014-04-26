module Ricer::Net::Irc
  class Connection < Ricer::Net::Connection
    
    MAXLEN = 255
    
    require 'uri'
    require 'socket'
    
    def connect
      begin
        @queue = {}
        if server.ssl?
          server.bot.log_info("Connecting via TLS to #{hostname}")
          ssl_context = OpenSSL::SSL::SSLContext.new
          ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE unless server.peer_verify
          sock = TCPSocket.new(hostname, port)
          @socket = OpenSSL::SSL::SSLSocket.new(sock, ssl_context)
          @socket.sync = true
          @socket.connect
        else
          server.bot.log_info("Connecting to #{hostname}")
          @socket = TCPSocket.new(hostname, port)
        end
        @connected = true
        @frame = Ricer::Net::Queue::Frame.new(server)
        send_queue
        fair_queue
      rescue => e
        server.bot.log_exception(e)
      end
    end
    
    def disconnect; disconnect! if @socket && @connected; end
    
    def get_line; begin; @socket.gets; rescue => e; disconnect; end; end

    def send_raw(line); send_line(line); end
    def send_pong(ping); send_line("PONG #{ping}"); end
    def send_join(channelname); send_line("JOIN #{channelname}"); end
    def send_part(channelname); send_line("PART #{channelname}"); end
    def send_quit(quitmessage); send_line("QUIT :#{quitmessage}"); end
    def send_notice(to, text, prefix); send_splitted to, "NOTICE #{to.name} :#{prefix}", text; end
    def send_privmsg(to, text, prefix); send_splitted to, "PRIVMSG #{to.name} :#{prefix}", text; end
    
    def login(nickname)
      server.bot.log_info("Logging in as #{nickname.next_nickname}")
      send_line "USER #{nickname.username} #{nickname.hostname} #{hostname} :#{nickname.realname}"
      send_nick(nickname)
    end
    
    def send_nick(nickname)
      server.botnick = nickname.next_nickname
      send_line "NICK #{nickname.next_nickname}"
    end
    
    def authenticate(nickname)
      send_line("PRIVMSG NickServ :IDENTIFY #{nickname.password}") if nickname.can_authenticate?
    end
    
    private
    
    def disconnect!
      @connected = false
      server.bot.log_info("Disconnecting from #{hostname}")
      @socket.close
      @socket = nil
    end
    
    def send_splitted(to, prefix, text)
      @queue[to] ||= Ricer::Net::Queue::Object.new(to)
      @server.ricer_sends(to, text)
      length = MAXLEN - prefix.length
      text.scan(Regexp.new(".{1,#{length}}(?:\s|$)|.{1,#{length}}")).map(&:strip).each do |line|
        send_queued(prefix+line, to)
      end
    end
    
    def send_queued(line, to)
      @queue[to].push(line)
    end
    
    def send_line(text, event=true)
      begin
        @frame.sent
        @server.ricer_sends(nil, text) if event
        @socket.write "#{text}\r\n"
      rescue => e
        server.bot.log_info("Disconnect from #{server.hostname}: #{e.message}")
        puts e.backtrace
        disconnect
      end
    end

    # Thread that reduces penalty for QueueObjects
    def fair_queue
      Ricer::Thread.new do |t|
        while @connected
          sleep(Ricer::Net::Queue::Frame::SECONDS)
          @queue.each do |to, queue|
            queue.reduce_penalty
          end
        end
      end
    end
    
    # Thread that sends QueueObject lines
    def send_queue
      Ricer::Thread.new do |t|
        while @connected
          @queue = Hash[@queue.sort_by{|to,queue|queue.penalty}]
          @queue.each do |to, queue|
            break if queue.empty? || @frame.exceeded?
            send_line queue.pop, false
          end
          sleep @frame.sleeptime
        end
      end
    end
    
  end
end
