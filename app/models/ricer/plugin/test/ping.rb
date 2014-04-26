module Ricer::Plugin::Test
  class Ping < Ricer::Plug::Trigger
    
    has_setting :count, type: :integer, scope: :bot, permission: :responsible, default:0

    def self.init
      @@count = 0
    end

    def execute
      @@count = @@count + 1
      rply :pong, :count => @@count, :global => global_count 
    end

    def global_count
      count = setting :count, :bot
      count = count + 1 
      setting :count, :bot, count
    end

  end
end
