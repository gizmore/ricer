module Ricer::Plugin::Rss
  class Rss < Ricer::Plug::Trigger
    
    has_subcommand :add
    has_subcommand :abbo
    has_subcommand :abbos
    has_subcommand :unabbo

    def self.upgrade_1
      Feed.upgrade_1
    end

    def ricer_on_global_startup
      Ricer::Plugin::Rss::Timer.new.start(self)
    end

  end
end
