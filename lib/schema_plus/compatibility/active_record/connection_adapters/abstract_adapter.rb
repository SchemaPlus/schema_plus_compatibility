module SchemaPlus::Compatibility
  module ActiveRecord
    module ConnectionAdapters
      module AbstractAdapter
        def tables_without_deprecation
          ActiveSupport::Deprecation.silence do
            tables
          end
        end
      end
    end
  end
end
