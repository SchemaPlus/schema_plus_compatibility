module SchemaPlus::Compatibility
  module ActiveRecord
    module ConnectionAdapters
      module AbstractAdapter
        def user_tables_only
          t = tables_only
          t.delete ::ActiveRecord::InternalMetadata.table_name if defined? ::ActiveRecord::InternalMetadata
          t
        end
      end
    end
  end
end
