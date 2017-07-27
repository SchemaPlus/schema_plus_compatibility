module SchemaPlus::Compatibility
  module ActiveRecord
    module ConnectionAdapters
      module AbstractAdapter
        @@internal_tables = []
        @@internal_tables << ::ActiveRecord::InternalMetadata.table_name if defined? ::ActiveRecord::InternalMetadata

        def user_tables_only
          t = tables_only
          t.delete_if {|table_name| @@internal_tables.include? table_name}
          t
        end

        def user_views_only
          # Out of the currently supported databases, only PostgreSQL has internal views.
          # Postgres can override this function, but the rest of the adapters can just return the views as is.
          views if respond_to? :views
        end
      end
    end
  end
end
