module Ricer::Plugin::Rss
  class Abbos < Ricer::Plug::AbboListTrigger
    
    is_subcommand
    
    def abbo_class; Ricer::Plugin::Rss::Feed; end
    
    def show_item(feed)
      tp :msg_feed, id:feed.id, name:feed.name, title:feed.title, description:feed.description
    end
    
    def show_list_item(feed)
      tp :msg_list_item, id:feed.id, name:feed.name
    end

  end
end
