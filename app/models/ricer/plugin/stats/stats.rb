module Ricer::Plugin::Stats
  class Stats < Ricer::Plug::Trigger
    
    def execute
      active = 0
      total = Ricer::Irc::Server.count
      channels = 0
      users = 0
      bot.servers.each do |server|
        if server.connected?
          active += 1
          channels += server.joined_channels.length
          users += server.connected_users.length
        end
      end
      plugins = 0
      events = 0
      bot.plugins.each do |p|
        if p < Ricer::Plug::Trigger
          plugins += 1
        else
          events += 1
        end
      end
      rply :stats, active_servers:active, total_servers:total, channels:channels, users:users, plugins:plugins, events:events
    end

  end
end
