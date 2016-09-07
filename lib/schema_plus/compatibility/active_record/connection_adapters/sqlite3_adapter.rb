module SchemaPlus::Compatibility
  module ActiveRecord
    module ConnectionAdapters
      module SQLite3Adapter
        def tables_only
          select_values("SELECT name FROM sqlite_master WHERE type = 'table' AND name <> 'sqlite_sequence'", 'SCHEMA')
        end
      end
    end
  end
end
