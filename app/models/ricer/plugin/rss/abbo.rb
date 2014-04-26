module Ricer::Plugin::Rss
  class Abbo < Ricer::Plug::AddAbboTrigger
    
    is_subcommand
    
    def abbo_class; Ricer::Plugin::Rss::Feed; end
    
  end
end
