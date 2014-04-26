module Ricer::Plugin::Cvs
  class Abbo < Ricer::Plug::AddAbboTrigger
    
    is_subcommand
    
    def abbo_class; Ricer::Plugin::Cvs::Repo; end
    
  end
end
