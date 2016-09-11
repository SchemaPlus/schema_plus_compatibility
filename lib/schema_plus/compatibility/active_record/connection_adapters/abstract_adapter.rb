module SchemaPlus::Compatibility
  module ActiveRecord
    module ConnectionAdapters
      module AbstractAdapter
        def user_tables_only
          t = tables_only
          t.delete "ar_internal_metadata"
          t
        end
      end
    end
  end
end
