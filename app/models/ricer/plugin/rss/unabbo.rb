module Ricer::Plugin::Rss
  class Unabbo < Ricer::Plug::RemoveAbboTrigger
    
    is_subcommand
    
    def abbo_class; Ricer::Plugin::Rss::Feed; end

  end
end
