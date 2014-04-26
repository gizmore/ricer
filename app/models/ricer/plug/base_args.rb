module Ricer::Plug
  class BaseArgs < BaseI18n
    
    attr_reader :irc_message

    def self.subcmdargc; class_variable_get(:@@SUBCMDARGC); end
    def self.minargs; class_variable_get(:@@MINARGS); end
    def self.maxargs; class_variable_get(:@@MAXARGS); end

    def initialize(irc_message=nil)
      @irc_message = irc_message;
      @argv = irc_message == nil ? nil : irc_message.argv
      @argv = @argv[self.class.subcmdargc..-1] unless @argv.nil?
      @argv = [] if @argv.nil?
      @argc = @argv.length
    end
    
    def user; @irc_message.user; end
    def server; @irc_message.server; end
    def channel; @irc_message.channel; end

    def line; @irc_message.line; end
    def argv; @argv; end
    def argc; @argc; end
    def args; @irc_message.args; end
    def argline; @irc_message.argline; end
    
    def self.init_argc
      class_variable_set(:@@SUBCMDARGC, self.trigger.count(' '))
    end
   
    def self.init_min_max()

      mmin = mmax = 0
      
#      begin
#        usage = I18n.t!(i18n_key+'.usage', :raise => true)
        usage.split('||').each do |u|
          max = u.scan('<').length
          optional = u.scan('[<').length
          min = max - optional
          max = 1024 if u.index('..>') != nil # Storyline text like this.
          mmin = min if min > mmin
          mmax = max if max > mmax
        end 
      #rescue I18n::MissingTranslationData
      #  bot.log_warn "Usage missing for #{name}"
      #end
      
      set_min_max(mmin, mmax)
      bot.log_info "I have set min/max parameter count for #{name} to #{minargs}-#{maxargs}."

    end
    
    def self.set_min_max(min, max)
      set_min_argc(min)
      set_max_argc(max)
    end

    def self.set_min_argc(min)
      class_variable_set(:@@MINARGS, min)
    end
   
    def self.set_max_argc(max)
      class_variable_set(:@@MAXARGS, max)
    end

  end
end
