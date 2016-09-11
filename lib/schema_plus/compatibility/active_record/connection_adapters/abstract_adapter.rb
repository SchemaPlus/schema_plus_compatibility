module SchemaPlus::Compatibility
  module ActiveRecord
    module ConnectionAdapters
      module AbstractAdapter
        def user_tables_only
          tables_only - ["ar_internal_metadata"]
        end
      end
    end
  end
end
