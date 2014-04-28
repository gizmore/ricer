module Ricer::Plugin::Abbos
  class Abbonement < ActiveRecord::Base
    
    belongs_to :abbo_item,   :class_name => 'Ricer::Plugin::Abbos::AbboItem'
    belongs_to :abbo_target, :class_name => 'Ricer::Plugin::Abbos::AbboTarget'
    
    def self.upgrade_1
      m = ActiveRecord::Migration.new
      m.create_table table_name do |t|
        t.integer :abbo_item_id,     null:false
        t.integer :abbo_target_id,   null:false
      end
    end
    
    def target
      abbo_target.target
    end
    
  end
  
  module Abbonementable
    def abbonementable_by(abbo_classes)
      class_eval do |klass|
        
        @abbo_classes = abbo_classes
        def abbo_classes; self.class.abbo_classes; end;
        def self.abbo_classes; @abbo_classes; end;
        
        def can_abbonement?(abbonement)
          abbo_classes.include?(abbonement.class)
        end
        
        def abbonemented?(abbonement)
          abbo(abbonement) != nil
        end
        
        def abbonement!(abbonement)
          return false unless can_abbonement?(abbonement)
          return true if abbonemented?(abbonement)
          Ricer::Plugin::Abbos::Abbonement.create!({abbo_target:abbo_target(abbonement), abbo_item:abbo_item})
          return true
        end
        
        def unabbonement!(abbonement)
          return true unless abbonemented?(abbonement)
          abbo_relation(abbonement).delete_all
        end
        
        def abbonements
          Ricer::Plugin::Abbos::Abbonement.where(abbo_item:abbo_item)
        end
    
        private
        def abbo_item
          Ricer::Plugin::Abbos::AbboItem.for(self)
        end
        def abbo_target(abbonement)
          Ricer::Plugin::Abbos::AbboTarget.for(abbonement)
        end
        
        def abbo_relation(abbonement)
          Ricer::Plugin::Abbos::Abbonement.where({abbo_target:abbo_target(abbonement), abbo_item:abbo_item})        
        end
        
        def abbo(abbonement)
          abbo_relation(abbonement).first
        end
        
      end
    end
  end
  
end

module Ricer::Plug
  
  class AbboTrigger < Trigger
    def abbo_class; throw "#{self.class.name} does not implement 'abbo_class' which should return ActiveRecord."; end
    def abbo_search(relation, term)
      if term.integer?
        relation.where(:id => term)
      else
        relation.search(term)
      end
    end
    def abbos_enabled(relation)
      relation
    end
    def abbos_visible(relation)
      relation
    end
    def abbo_find(relation, term)
      relation.find(term)
    end
    protected
    def abbo_classname
      abbo_class.model_name.human
    end
    def abbos_item(abbo_item)
      Ricer::Plugin::Abbos::AbboItem.for(abbo_item)
    end
    def abbo_item(arg)
      relation = abbo_class.all
      relation = abbos_enabled(relation)
      relation = abbos_visible(relation)
      abbo_find(relation, arg)
    end
    def abbos_target
      Ricer::Plugin::Abbos::AbboTarget.for(abbo_target)
    end
    def abbo_target
      @irc_message.channel||@irc_message.user
    end
  end
  
  class AddAbboTrigger < AbboTrigger
    
    def self.i18n_usage_key; 'ricer.plug.abbo.add_abbo.usage'; end
    def description; I18n.t('ricer.plug.abbo.add_abbo.description'); end
    
    def execute
      abbo_item = self.abbo_item(argv[0])
      return rplyr 'plug.abbo.err_abbo_item', classname:abbo_classname if abbo_item.nil?
      return rplyr 'plug.abbo.err_invalid_target', classname:abbo_classname unless abbo_item.can_abbonement?(abbo_target)
      return rplyr 'plug.abbo.err_abbo_twice', classname:abbo_classname if abbo_item.abbonemented?(abbo_target)
      Ricer::Plugin::Abbos::Abbonement.create({abbo_target:abbos_target, abbo_item:abbos_item(abbo_item)})
      return rplyr 'plug.abbo.msg_abbonemented', classname:abbo_classname
    end
  end

  class RemoveAbboTrigger < AbboTrigger
    def self.i18n_usage_key; 'ricer.plug.abbo.remove_abbo.usage'; end
    def description; I18n.t('ricer.plug.abbo.remove_abbo.description'); end
    def execute
      abbo_item = self.abbo_item(argv[0])
      return rplyr 'plug.abbo.err_abbo_item', classname:abbo_classname if abbo_item.nil?
      return rplyr 'plug.abbo.err_invalid_target', classname:abbo_classname unless abbo_item.can_abbonement?(abbo_target)
      return rplyr 'plug.abbo.err_not_abboed' unless abbo_item.abbonemented?(abbo_target)
      Ricer::Plugin::Abbos::Abbonement.where({abbo_target:abbos_target, abbo_item:abbos_item(abbo_item)}).delete_all
      return rplyr 'plug.abbo.msg_unabbonemented', classname:abbo_classname
    end
  end

  class AbboListTrigger < ListTrigger
    
    def abbo_class; throw "#{self.class.name} does not implement 'abbo_class' which should return ActiveRecord."; end
    
    def list_class; abbo_class; end
    
  end
end

ActiveRecord::Base.extend Ricer::Plugin::Abbos::Abbonementable
