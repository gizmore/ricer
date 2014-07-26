module Ricer::Plugin::Rss
  class List < Ricer::Plug::ListTrigger
    
    def self.trigger; I18n.t('ricer.plugin.rss.list.trigger'); end
    
    def list_class; Feed; end;
    def per_page; 10; end
    
    def show_item(feed)
      tp :msg_feed, id:feed.id, name:feed.name, title:feed.title, description:feed.description
    end
    
    def show_list_item(feed)
      tp :msg_list_item, id:feed.id, name:feed.name
    end

  end
end
