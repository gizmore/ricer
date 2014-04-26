module ActiveRecord

  class Base
    def self.with_global_orm_mapping
      class_eval do |cl|
        cl.class_variable_set('@@CACHE', {})
        def global_cache_table(record)
          c = self.class.class_variable_get('@@CACHE')
          c[record.id] ||= record if record.should_cache?
          c[record.id] || record
        end
      end
    end
  end

  class Relation
    
    alias :original_exec_queries :exec_queries
    
    def exec_queries
      new_records = []
      original_exec_queries.each do |record|
        break unless record.respond_to? :global_cache_table
        new_records.push(record.global_cache_table(record))
      end
      @records = new_records unless new_records.empty?
      @records
    end
    
  end
end
