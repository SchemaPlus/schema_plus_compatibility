module SchemaPlus::Compatibility
  module ActiveRecord
    module ConnectionAdapters
      module PostgreSQLAdapter
        def tables_only
          _pg_relations(%w{r}) # (r)elation/table
        end

        def user_views_only
          _pg_relations(%w{v m}, _filter_user_data_sources_sql) # (v)iew, (m)aterialized view
        end

        # Filter for user  data sources
        def _filter_user_data_sources_sql
          sql = "AND c.relname NOT LIKE 'pg\\_%'"
          sql += " AND schemaname != 'postgis'" if adapter_name == 'PostGIS'
          sql
        end

        def _pg_relations(rel_types, extra_sql = nil)
          sql = _pg_relations_sql(rel_types)
          if extra_sql
            sql << "\n"
            sql << extra_sql
          end
          select_values(sql, 'SCHEMA')
        end

        # This private method tries the model the way ActiveRecord queries PostgreSQL relations, but allow for modifications
        # by middleware.
        def _pg_relations_sql(rel_types)
          rel_type_query = rel_types.map{|t| "'#{t}'"}.join(',')
          <<-SQL
            SELECT c.relname
            FROM pg_class c
            LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
            WHERE c.relkind IN (#{rel_type_query})
            AND n.nspname = ANY (current_schemas(false))
          SQL
        end
      end
    end
  end
end
