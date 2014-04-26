module Ricer::Plugin::Rss
  class Timer
    
    def start(plugin)
      Ricer::Thread.new do |t|
        while true
          puts "Checking feeds"
          check_feeds(plugin)
          sleep(120)
        end
      end
    end
    
    def check_feeds(plugin)
      Feed.enabled.each do |feed|
        puts "Checking feed #{feed.title}"
        feed.check_feed(plugin)
        sleep(3)
      end
    end
    
  end
end
