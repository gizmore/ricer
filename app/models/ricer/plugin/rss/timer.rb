module Ricer::Plugin::Rss
  class Timer
    
    def bot
      Ricer::Bot.instance      
    end
    
    def start(plugin)
      Ricer::Thread.new do |t|
        while true
          puts "Checking feeds"
          begin
            check_feeds(plugin)
          rescue => e
            bot.log_exception e
          end
          sleep(120)
        end
      end
    end
    
    def check_feeds(plugin)
      Feed.all.enabled.each do |feed|
        begin
          puts "Checking feed #{feed.title}"
          feed.check_feed(plugin)
          sleep(3)
        rescue => e
          bot.log_exception e
        end
      end
    end
    
  end
end
