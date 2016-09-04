module SchemaPlus::Compatibility
  module ActiveRecord
    module ConnectionAdapters
      module Mysql2Adapter
        def tables_without_deprecation
          select_values("SHOW FULL TABLES WHERE table_type != 'VIEW'", "SCHEMA")
        end
      end
    end
  end
end
