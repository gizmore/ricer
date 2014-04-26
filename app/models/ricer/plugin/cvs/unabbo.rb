module Ricer::Plugin::Cvs
  class Unabbo < Ricer::Plug::RemoveAbboTrigger
    
    is_subcommand
    
    def abbo_class; Ricer::Plugin::Cvs::Repo; end

  end
end
