module DataSourceHelpers
  def create_dummy_view(v, t)
    drop_dummy_view v
    connection.execute "CREATE VIEW #{v} AS SELECT * FROM #{t}"
  end

  def drop_dummy_view(v)
    connection.execute "DROP VIEW IF EXISTS #{v}"
  end

  def create_dummy_materialized_view(v, t)
    if DataSourceHelpers.is_postgresql?
      drop_dummy_materialized_view v
      connection.execute "CREATE MATERIALIZED VIEW #{v} AS SELECT * FROM #{t}"
    end
  end

  def drop_dummy_materialized_view(v)
    if DataSourceHelpers.is_postgresql?
      connection.execute "DROP MATERIALIZED VIEW IF EXISTS #{v}"
    end
  end

  def create_dummy_data_sources
    begin
      connection.tables_only.each do |table|
        connection.drop_table table, force: :cascade
      end
      ActiveRecord::InternalMetadata.create_table if ActiveRecord::VERSION::MAJOR >= 5 # ensure metadata table exists
      connection.create_table :t1
      connection.create_table :t2
      create_dummy_view :v1, :t1
      create_dummy_view :v2, :t2
      create_dummy_materialized_view :mv1, :t1
      create_dummy_materialized_view :mv2, :t2
      yield
    ensure
      drop_dummy_view :v1
      drop_dummy_view :v2
      drop_dummy_materialized_view :mv1
      drop_dummy_materialized_view :mv2
      connection.drop_table :t1, if_exists: true
      connection.drop_table :t2, if_exists: true
    end
  end

  def self.is_postgresql?
    ActiveRecord::Base.connection.instance_of? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  end
end
