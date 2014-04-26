module Ricer::Plugin::Log
  class Binlog
    
    def self.upgrade_1
      m = ActiveRecord::Migration
      m.create_table :binlogs do |t|
        t.integer  :user_id
        t.integer  :plugin_id
        t.integer  :channel_id
        t.string   :command, :length => 8
        t.string   :message
        t.boolean  :input, :default => true
        t.datetime :created_at
      end
    end

    def self.irc_message(irc_message, input)
      self.create!({
        user_id: irc_message.user_id,
        plugin_id: irc_message.plugin_id,
        channel_id: irc_message.channel_id,
        command: irc_message.command,
        message: input ? irc_message.raw : irc_message.argsline,
        input: input,
        created_at: irc_message.time,
      })
    end

  end
end
