module SchemaPlus::Compatibility
  module ActiveRecord
    module ConnectionAdapters
      module AbstractAdapter
        def user_tables_only
          t = tables_only
          t.delete "ar_internal_metadata"
          t
        end

        def tables_only
          # In the future (AR 5.1?) tables may really return just tables instead of data
          # sources, and the deprecation warning will be removed. We would
          # have to update the method then.
          #
          # For consistency's sake, this method is overridden in all standard adapters
          # (SQLite3, MySQL and Postgres) with a proper tables-only implementation, so you're
          # really going to get ONLY tables and no warning for these 3 databases across all
          # current and future versions of AR.
          # For non-supported DBs, try our best by trying first to subtract #views from #data_sources
          # but we have to return the plain old #tables result in AR4.2.
          all_sources = (try :data_sources) || tables
          views_only = (try :views) || []
          all_sources - views_only
        end
      end
    end
  end
end
