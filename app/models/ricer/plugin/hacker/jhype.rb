module Ricer::Plugin::Hacker
  class Jhype < Ricer::Plug::Trigger
    
    require 'net/http'
    
    DIR = 'http://sabrefilms.co.uk/store/'
    
    has_setting :stocksize, scope: :bot,     permission: :responsible, type: :integer, default: 0
    has_setting :announce,  scope: :channel, permission: :operator,    type: :boolean, default: false

    def ricer_on_global_startup
      Ricer::Thread.new do |t|
        begin
          while true
            check_for_new_pictures
            sleep(6.hours)
          end
        rescue => e
          puts e
          puts e.backtrace
        end
      end
    end
    
    def check_for_new_pictures
      amt = setting(:stocksize, :bot)
      uri = URI(DIR)
      http = Net::HTTP.new(uri.host, uri.port)
      while true
        amt += 1
        jlink = jlink(amt)
        uri = URI(jlink)
        response = http.request Net::HTTP::Head.new(uri)
        if response.code == '200'
          announce(jlink)
          setting(:stocksize, :bot, amt)
        else
          break
        end
      end
    end
    
    def announce(jlink)
      bot.servers.each do |server|
        server.joined_channels.each do |k,channel|
          if foreign_setting(server, nil, channel, :announce, :channel)
            channel.localize!
            channel.send_privmsg t(:announce, link:jlink)
          end
        end
      end
    end
    
    def jlink(num)
      "#{DIR}j#{num}.jpg"
    end
    
    def execute
      amt = setting(:stocksize, :bot)
      return rply :err_none if amt == 0
      begin
        num = argc == 0 ? rand(1..amt) : argv[0].to_i
      rescue => e
        return show_help
      end
      return show_help unless num.between?(1, amt)

      rply :show, num:num, of:amt, link:jlink(num)
    end
    
  end
end
