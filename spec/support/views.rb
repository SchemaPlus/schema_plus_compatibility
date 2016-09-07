module ViewSupport
  module ActiveRecord
    module ConnectionAdapters
      module AbstractAdapter
        # Create a view given the SQL definition.  Specify :force => true
        # to first drop the view if it already exists.
        def create_dummy_view(view_name)
          drop_dummy_view(view_name)
          execute "CREATE VIEW #{view_name} AS SELECT 1 AS item"
        end

        # Drop the named view.  Specify :if_exists => true
        # to fail silently if the view doesn't exist.
        def drop_dummy_view(view_name)
          execute "DROP VIEW IF EXISTS #{view_name}"
        end
      end
    end
  end
end

