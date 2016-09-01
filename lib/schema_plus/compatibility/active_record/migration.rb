module SchemaPlus::Compatibility
  module ActiveRecord
    module Migration
      module ClassMethods
        def latest_version
          begin
            ::ActiveRecord::Migration::Current
          rescue
            self
          end
        end
      end
    end
  end
end
