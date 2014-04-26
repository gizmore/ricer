module Ricer
  class Botloader
    
    def rice_up
      @need_restart = false
      @valid = true
      rice_up_servers
      rice_up_plugins
      log_info("I have #{@servers.length} servers and #{@plugins.length} plugins registered.");
    end
    
    def rice_up_servers
      @servers = Irc::Server.enabled.all
      @servers.each do |server|
        throw "Server #{server.shortname} has no nickname!" if server.nicknames.count == 0
      end
    end
    
    def rice_up_plugins
      @valid = true
      @plugins = [];
      @subcommands = [];
      @plugdirs.each do |plugdir|
        Dir[plugdir].each do |dir|
          rice_up_export dir
        end
      end
      @plugdirs.each do |plugdir|
        Dir[plugdir].each do |dir|
          rice_up_plugin dir
        end
      end
      @plugins = Ricer::Plug::Event.sort_plugins(@plugins)
      I18n.reload!
      @plugins.each do |plugin|
        rice_up_plugin_init plugin
      end
    end
    
    private
    
    def rice_up_plugin_init(plugin)
      plugin.init
      plugin.init_argc
      plugin.init_min_max if plugin < Ricer::Plug::Trigger
    end
    
    def rice_up_export(plugdir)
      # begin
        Dir[plugdir+'/export/*'].each do |path|
          if File.file?(path)
            begin
              puts path
              log_info("Loading export class #{path}")
              load path
            rescue => e
              log_error("Error in #{path}")
              log_exception(e)
              @valid = false
            end
          end
        end
      # rescue => e
        # @valid = false
        # log_error("Error in #{plugdir}")
        # log_exception(e)
      # end
    end
    
    def rice_up_plugin(plugdir)
      length = plugdir.length + 1;
      modulename = plugdir[(plugdir.rindex('/')+1)..-1].camelize
      log_info "Loding plugin module folder '#{modulename}' from '#{plugdir}'."
      
      Dir[plugdir+'/*'].each do |path|
        if File.file?(path)
          begin
            classname = path[length..-4].camelize
            log_info "Loding plugin '#{modulename}'::#{classname}."
            load path
            classobject = Object.const_get('Ricer').const_get('Plugin').const_get(modulename).const_get(classname)
            if classobject < Ricer::Plug::Base && classobject.env_enabled?

              classobject.class_variable_set(:@@MAX_CHARACTERS, 255) unless classobject.class_variable_defined?(:@@MAX_CHARACTERS)

              classobject.class_variable_set(:@@SCOPE, :everywhere) unless classobject.class_variable_defined?(:@@SCOPE)
              classobject.class_variable_set(:@@TRIGGER, classobject.downcase_trigger) unless classobject.class_variable_defined?(:@@TRIGGER)
              classobject.class_variable_set(:@@PERMISSION, :public) unless classobject.class_variable_defined?(:@@PERMISSION)
              
              settings = classobject.class_variable_defined?(:@@SETTINGS) ? classobject.class_variable_get(:@@SETTINGS) : {}
              settings = settings.merge(classobject.default_settings)
              classobject.class_variable_set(:@@SETTINGS, settings)
              
              classobject.class_variable_set(:@@PLUGPATH, path)
              classobject.validate!
              rice_up_plugin_install classobject
              #rice_up_plugin_settings classobject
              
              if classobject.class_variable_defined?(:@@SUBCOMMAND)
                @subcommands.push(classobject)
              else
                @plugins.push(classobject)
              end
               
            end
          rescue Exception => e
            log_error("Error in #{path}")
            log_exception(e)
            @valid = false
          end
        end
      end
      rice_up_dir_i18n(plugdir+'/lang/*')
    end
    
#    def rice_up_plugin_settings(classobject)
#      classobject.new.settings.each do |k,v|
#        rice_up_plugin_setting(classobject, k, v)
#      end
#    end

#    def rice_up_plugin_setting(classobject, name, hash)
#      Ricer::Irc::SettingValidator.validate_definition!(classobject, name, hash)
#    end
    
    def rice_up_plugin_install(classobject)
      plugin = Ricer::Irc::Plugin.where(:name => classobject.name).first
      if plugin.nil?
        plugin = Ricer::Irc::Plugin.create!(:name => classobject.name) if p.nil?
        old_revision = 0
      else
        throw "Invalid plugin revision for #{classobject.name}" unless (classobject.revision.is_a? Integer) && (classobject.revision.between?(0, 1000))
        old_revision = plugin.revision
      end
      new_revision = old_revision
      
      # Set plugin_id, the plugs/events/triggers are no activerecord
      classobject.class_variable_set(:@@PLUGID, plugin.id)

      upgraded = false
      successful = true
       
      # Upgrade db
      while classobject.revision > old_revision
        @need_restart = true
        upgraded = true
        old_revision += 1
        log_info "Installing #{classobject.name}" if old_revision == 1
        log_info "Upgrading #{classobject.name} to #{old_revision}" if old_revision >= 2
        begin
          classobject.send('upgrade_'+old_revision.to_s)
          plugin.revision = old_revision
          upgraded = true
        rescue Exception => e
          successful = false
          log_exception(e)
          break
        end
      end
      
      # General upgrade when upgraded
      begin
        classobject.install
      rescue Exception => e
        successful = false
        log_exception(e)
      end
      
      # Error?
      throw "Plugin #{classobject.name} could not be installed successfully." unless successful
      
      # Save!
      plugin.save!
      
    end
    
    def rice_up_plugin_i18n(classobject)
      rice_up_dir_i18n(classobject.langdir+'*')
    end
    
    def rice_up_dir_i18n(dir)
      Dir[dir].each do |path|
        I18n.load_path.push(path)
      end
    end
    
  end
end