module Ricer::Plugin::Rss
  class Abbos < Ricer::Plug::AbboListTrigger
    
    is_subcommand
    
    def abbo_class; Ricer::Plugin::Rss::Feed; end

  end
end
