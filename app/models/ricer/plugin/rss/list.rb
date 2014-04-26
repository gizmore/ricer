module Ricer::Plugin::Rss
  class List < Ricer::Plug::ListTrigger
    
    def self.trigger; I18n.t('ricer.plugin.rss.list.trigger'); end
    
    def list_class; Feed; end;
    def per_page; 10; end
    
#    def search_relation(relation)
      #feed = Feed.enabled.by_name(name)
      #return show_feed(feed) unless feed.nil?
#      feeds = Feed.enabled.search(name)
#      return show_feed(feeds.first) if feeds.count == 1
#    end
    
    
    # def execute
      # return rply :err_no_feeds if Feed.enabled.count == 0
      # arg = argv == nil ? '1' : argv[0]
      # arg.integer? ? show_page(arg) : search_feed(arg)
    # end
#     
    # def show_page(page)
      # show_feeds(Feed.enabled, page)
    # end
#     
    # def show_feeds(feeds, page)
      # feeds = feeds.page(page.to_i)
      # return rply :err_page unless feeds.count > 0
      # out = []
      # feeds.each do |feed|
        # out.push("#{feed.name}")
      # end
      # rply :msg_page, page:feeds.current_page, pages:feeds.total_pages, out:out.join(', ') 
    # end
#     
    # def search_feed(name)
      # feed = Feed.enabled.by_name(name)
      # return show_feed(feed) unless feed.nil?
      # feeds = Feed.enabled.search(name)
      # return show_feed(feeds.first) if feeds.count == 1
      # page = argc == 1 ? 1 : argv[0]
      # page = 1 unless page.integer?
      # return show_feeds matches, page
    # end
    
    def show_item(feed)
      t :msg_feed, id:feed.id, name:feed.name, title:feed.title, description:feed.description
    end
    
    def show_list_item(feed)
      t :msg_list_item, id:feed.id, name:feed.name
    end

  end
end
