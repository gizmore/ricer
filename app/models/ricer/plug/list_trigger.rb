module Ricer::Plug
  class ListTrigger < Trigger

    def list_class; throw "#{self.class.name} does not implement 'def list_class' which should return an ActiveRecord"; end
    def list_page; argv[0]; end
    def search_page(page); begin; argv[1].to_i; rescue => e; 1; end; end
    def per_page; 10; end
    
    def self.i18n_usage_key; 'ricer.plug.list.usage'; end

    def execute
      if arg = list_page
        arg.integer? ? show_page(arg) : search_list(arg)
      else
        show_welcome
      end
    end
    
    def show_welcome()
      show_help
    end
    
    protected
    
    def description
      I18n.t('ricer.plug.list.description', classname:list_class.model_name.human, count:list_class.all.count)
    end
    
    def show_page(page)
      show_items(enabled_relation(list_class.all).order("#{list_class.table_name}.created_at"), page)
    end
    
    def show_items(relation, page)
      items = relation.page(page.to_i).per(per_page)
      out = []
      items.each do |item|
        out.push(show_list_item(item))
      end
      return rplyr 'plug.list.err_no_list_items', classname:list_class.model_name.human if out.length == 0
      rplyr 'plug.list.msg_list_item_page', classname:list_class.model_name.human, page:items.current_page, pages:items.total_pages, out:out.join(', ')
    end
    
    def enabled_relation(relation)
      return relation.send(:enabled?) if relation.respond_to?(:enabled?)
      return relation.send(:deleted?) if relation.respond_to?(:deleted?)
      return relation
    end

    def search_relation(relation, arg)
      relation.search(arg)
    end
    
    def search_list(arg)
      relation = list_class.all
      relation = enabled_relation(relation)
      relation = search_relation(relation, arg)
      return reply show_item(relation.first) if relation.count == 1
      show_items(relation, search_page)
    end
    
    def show_item(item)
      t 'plug.list.msg_show_item', :classname => item.class.model_name.human, item_id:item.id, name:item.name
    end
    
    def show_list_item(item)
      t 'plug.list.msg_show_list_item', :classname => item.class.model_name.human, item_id:item.id, name:item.name
    end

  end
end

