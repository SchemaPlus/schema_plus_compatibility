require 'schema_plus/core'

require_relative 'compatibility/version'
require_relative 'compatibility/active_record/connection_adapters/abstract_adapter'
require_relative 'compatibility/active_record/migration/migration'

SchemaMonkey.register SchemaPlus::Compatibility
