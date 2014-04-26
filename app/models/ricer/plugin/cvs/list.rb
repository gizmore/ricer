module Ricer::Plugin::Cvs
  class List < Ricer::Plug::ListTrigger
    
    is_subcommand
    
    def list_class; Repo; end
    
    def show_item(repo)
      tt 'ricer.plugin.cvs.msg_show_item', repo_id:repo.id, name:repo.name, path:repo.uri.path
    end
    
    def show_list_item(repo)
      tt 'ricer.plugin.cvs.msg_show_list_item', repo_id:repo.id, name:repo.name
    end
    
  end
end
