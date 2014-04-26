module Ricer::Plug
  class BaseI18n < BaseIrc

    def i18n_key; self.class.i18n_key; end
    def self.i18n_key; ((name.gsub('::', '.')) + '.').downcase; end
    
    def t(*args); _t(args); end;     
    def tt(*args); _tt(args); end;     
    def tp(*args); _tp(args); end;     
    def tr(*args); _tr(args); end;     
    
    def nrply(*args); nreply _t(args); end
    def nrplyt(*args); nreply _tt(args); end
    def nrplyp(*args); nreply _tp(args); end
    def nrplyr(*args); nreply _tr(args); end
    def nreply(text); @irc_message.nreply(text); end
    
    def rply(*args); reply _t(args); end
    def rplyt(*args); reply _tt(args); end
    def rplyp(*args); reply _tp(args); end
    def rplyr(*args); reply _tr(args); end
    def reply(text); @irc_message.reply(text); end

    def show_help; reply(help); end
    
    def self.downcase_trigger; classname.downcase; end
    def self.i18n_trigger
      key = "#{i18n_key}trigger"
      I18n.exists?(key) ? I18n.t(key) : class_variable_get(:@@TRIGGER)
    end
    
    protected
    
    def help
      _tt(['ricer.msg_help', {usage:full_usage, description:description, cmdscope:scopelabel, permission:permissionlabel}])
    end

    def full_usage
      u = usage
      c = self.class.trigger
      return u.empty? ? c : "#{c} #{u}"
    end
    
    def self.i18n_usage_key; i18n_key+'.usage'; end
    def self.usage; begin; I18n.t!(i18n_usage_key); rescue => e; ''; end; end
    def usage; self.class.usage; end
    
    def description
      begin; _t([:description]); rescue => e; ''; end
    end
    
    def scopelabel
      I18n.t('ricer.irc.scope_in.'+(Ricer::Irc::Scope.by_name(self.class.scope).char))      
    end
      
    def permissionlabel
      Ricer::Irc::Priviledge.to_label(self.class.permission)
    end

    private
    
    def _t(args)
      args[0] = i18n_key + args[0].to_s
      _tt(args)
    end
    
    def _tp(args)
      args[0] = "ricer.plugin.#{self.class.modulename.downcase}.#{args[0].to_s}"
      _tt(args)
    end

    def _tr(args)
      args[0] = "ricer.#{args[0].to_s}"
      _tt(args)
    end
    
    def _tt(args)
      case I18n.locale.to_sym
      when :bot; _tt_bot(args)
      when :ibdes; _tt_ibdes(args)
      else; _trp I18n.t(args.shift, args.shift)
      end
    end
    
    def _trp(s)
      begin
        s.gsub('$TRIGGER$', @irc_message.reply_trigger).gsub('$BOT$', server.botnick).gsub('$COMMAND$', self.class.trigger)
      rescue => e
        puts e.message
        puts e.backtrace
        s.inspect
      end
    end

  end
end
