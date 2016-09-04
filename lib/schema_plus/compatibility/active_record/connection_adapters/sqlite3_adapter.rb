module SchemaPlus::Compatibility
  module ActiveRecord
    module ConnectionAdapters
      module SQLite3Adapter
        def tables_without_deprecation
          select_values("SELECT name FROM sqlite_master WHERE type = 'table' AND name <> 'sqlite_sequence'", 'SCHEMA')
        end
      end
    end
  end
end
