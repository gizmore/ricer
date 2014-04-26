require 'singleton'
module Ricer
  class Bot < Botloader
    
    include Singleton

    attr_accessor :running, :failed, :rand, :reboot

    attr_reader :servers, :events, :plugins, :valid
    attr_reader :launchtime, :max_memory, :max_mem_time

    def randseed; Ricer::Application.config.rice_seeds; end
    def chopsticks; Ricer::Application.config.chopsticks; end
    def version; Ricer::Application.config.ricer_version; end
    def builddate; Ricer::Application.config.ricer_version_date; end

    def initialize
      @valid = true
      @reboot = false
      @logger = logger('log/ricer/bot.log')
      @valid = false if @logger.nil?
      @running = false
      @launchtime = Time.now
      @max_memory = 0
      @max_mem_time = Time.now
      memory_peak
      @plugdirs = []
      register_plugin_directory('app/models/ricer/plugin') if @valid
    end
    
    def register_plugin_directory(path)
      throw "Ricer not valid so you cannot add plugin directories." unless @valid
      #path.rtrim!('/*')
      path = File.dirname(path) if File.file?(path)
      path += '/*'
      @plugdirs.push(path) unless @plugdirs.include?(path)
    end

    # Some stats #    
    def uptime; Time.now - @launchtime; end
    def display_uptime; Ricer::Irc::Lib.instance.human_duration(uptime); end
    def memory; OS.rss_bytes * 1024; end
    def memory_peak
      mem = memory
      if mem >= @max_memory
        @max_memory = mem
        @max_mem_time = Time.now
      end
      mem
    end
    
    # Launch!
    def run
      if @need_restart
        log_info("Ricer needs a restart, because plugins were installed or upgraded.")
      elsif @valid
        log_info("Starting ricer bot. Config seems valid!")
        # Running!
        init_random
        @running = true
        # Fire server threads
        start_servers
        # Wait for them to join and crash
        cleanup_loop
      else
        log_info("Config seems invalid!")
      end
      # Return 1 unless we get killed with .reboot
      Kernel.exit(@reboot)
    end
    
    def init_random
      seed = randseed
      @rand = Random.new(seed)
      log_info "Seeded random generator with #{seed}"
    end
    
    
    def start_servers
      log_info("Ricer::Bot.start_servers")
      @servers.each do |server|
        sleep 1.second
        Ricer::Thread.new do |t|
          server.startup
        end
      end
    end
    
    def cleanup_loop
      @started_up = false
      log_info("Going into cleanup loop.")
      while @running
        begin
          sleep 10
          check_started_up unless @started_up
        rescue SystemExit, Interrupt => e
          servers.each do |server|
            server.send_quit('Caught SystemExit exception.')
          end
          @running = false
          raise
        rescue Exception => e
          puts e
          puts e.backtrace.join("\n")
          @running = false
        end
      end
    end
    
    def check_started_up
      @servers.each do |server|
        return unless server.started_up? 
      end
      # We started up!
      @started_up = true

      # Fire startup event: ricer_on_startup
      @servers.each do |server|
        irc_message = server.message_object
        irc_message.server = server
        server.ricer_on('startup', irc_message)
      end
      
      # Fire startup event: ricer_on_global_startup
      server = @servers[0]
      irc_message = server.message_object
      irc_message.server = server
      server.ricer_on('global_startup', irc_message)
    end
    
    ###############
    ### Logging ###
    ###############
    def logger(filename)
      begin
        filename = "#{Rails.root}/log/#{filename}"
        dir = File.dirname(filename)
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
        Logger.new(filename)
      rescue => e
        puts "Cannot create logfile!"
        puts e
        puts e.backtrace.join("\n")
        mail_exception(e)
      end
    end
    
    def log_verbose(msg); puts msg unless chopsticks; end
    def log_debug(msg); log('debug', msg); end
    def log_info(msg); log('info', msg); end
    def log_warn(msg); log('warn', msg); end
    def log_error(msg); log('error', msg); end
    def log_fatal(msg); log('fatal', msg); end
    def log_exception(exception)
      log_fatal("---------------------")
      log_fatal(exception.to_s)
      log_fatal(exception.backtrace.join("\n"))
      log_fatal("---------------------")
      mail_exception(exception)
    end
    # Mail first exception after a message
    def mail_exception(exception)
      return if @failed; @failed = true
      Thread.new do |t|
        BotMailer.exception(exception).deliver
      end
    end
    private
    def log(level, msg)
      msg = "[#{level.upcase}] #{msg}"
      puts msg
      @logger.send(level, msg)
    end

  end
end
