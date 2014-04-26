module Ricer::Plugin::Debug
  class Plugdebug < Ricer::Plug::Trigger
    
    trigger_is :pdbg

    def execute
      plug = instance_by_arg(argv[0])
      klass = plug.class
      return rplyr :err_plugin if plug.nil?
      rply :msg_plug_info,
        modulename: klass.modulename,
        classname: klass.classname,
        path: klass.plugin_path,
        trigger: klass.trigger,
        plugscope: Ricer::Irc::Scope.by_name(klass.scope).to_label,
        permission: Ricer::Irc::Priviledge.by_name(klass.permission).to_label
    end
    
  end
end
