module Ricer::Plugin::Rss
  class Add < Ricer::Plug::Trigger
    
    is_subcommand

    needs_permission :operator
    
    def execute
      
      url = argv[1]
      name = argv[0]

      return rply :err_dup_url unless Feed.by_url(url).nil?
      return rply :err_dup_name unless Feed.by_name(name).nil?
      
      feed = Feed.new({name:name, url:url, user:user})
      
      return rply :err_test unless feed.working?
      
      feed.save!
      
      # Auto Abbo for issuer
      feed.abbonement!(channel == nil ? user : channel)
#      feed.abbonement_by(channel == nil ? user : channel)
      
      return rply :msg_added, id:feed.id, name:name, title:feed.title, description:feed.description
      
    end
    
  end
end
