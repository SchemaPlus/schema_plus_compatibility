# frozen_string_literal: true

require 'schema_monkey'

require_relative 'compatibility/version'
require_relative 'compatibility/active_record/connection_adapters/abstract_adapter'
require_relative 'compatibility/active_record/migration'

module SchemaPlus::Compatibility
  module ActiveRecord
    module ConnectionAdapters
      autoload :Mysql2Adapter, 'schema_plus/compatibility/active_record/connection_adapters/mysql2_adapter'
      autoload :PostgreSQLAdapter, 'schema_plus/compatibility/active_record/connection_adapters/postgresql_adapter'
      autoload :SQLite3Adapter, 'schema_plus/compatibility/active_record/connection_adapters/sqlite3_adapter'
    end
  end
end

SchemaMonkey.register SchemaPlus::Compatibility
