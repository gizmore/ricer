module Ricer::Plugin::Config
  class Help < Ricer::Plug::Trigger
    
    bruteforce_protected :always => false
    
    def execute
      argc == 0 ? show_triggers : show_help(argv[0])
    end
    
    protected
    
    def help_plugins
      triggers = []
      Ricer::Bot.instance.plugins.each do |plugin|
        triggers.push(plugin) if plugin < Ricer::Plug::Trigger
      end
      triggers
    end
    
    private
    
    def show_triggers
      return if bruteforcing?
      grouped = collect_groups
      grouped = Hash[grouped.sort]
      grouped.each do |k,v|; grouped[k] = v.sort; end
      nrplyp :msg_triggers, :triggers => grouped_output(grouped)
    end
    
    def collect_groups()
      grouped = {}
      help_plugins.each do |plugin|
        instance = plugin.new(@irc_message)
        if (plugin.in_scope?(channel) && plugin.permitted?(user, channel))
          m = plugin.modulename
          grouped[m] = [] if grouped[m].nil?
          grouped[m].push(plugin.trigger)
        end
      end
      return grouped
    end
    
    def grouped_output(grouped)
      out = []
      grouped.each do |k,v|
        group = bold(k) + ': '
        group += v.join(', ')
        out.push(group)
      end
      out.join('. ')
    end
    
    def show_help(arg)
      instance = instance_by_arg(arg)
      return rplyt 'ricer.err_plugin' if instance.nil?
      return instance.show_help if instance.class < Ricer::Plug::Trigger
      return rply :msg_event_info, :name => instance.class.trigger, :info => instance.description
    end

  end

end
