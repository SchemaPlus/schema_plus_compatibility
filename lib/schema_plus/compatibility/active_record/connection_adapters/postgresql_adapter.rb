# frozen_string_literal: true

module SchemaPlus::Compatibility
  module ActiveRecord
    module ConnectionAdapters
      module PostgreSQLAdapter
        def tables_only
          select_values(<<-SQL, "SCHEMA")
            SELECT c.relname
            FROM pg_class c
            LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
            WHERE c.relkind IN ('r') -- (r)elation/table
            AND n.nspname = ANY (current_schemas(false))
          SQL
        end
      end
    end
  end
end
