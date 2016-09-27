# encoding: utf-8
require 'spec_helper'
require 'support/helpers'

describe 'tables_only' do
  let(:connection) { ActiveRecord::Base.connection }

  around(:each) do |example|
    create_dummy_data_sources &example
  end

  it 'does not cause deprecation' do
    expect(ActiveSupport::Deprecation).not_to receive(:warn)
    connection.tables_only
  end

  let(:ar_internal_tables) {
    if ActiveRecord::VERSION::MAJOR >= 5
      [ActiveRecord::InternalMetadata.table_name]
    else
      []
    end
  }

  it 'lists all tables' do
    expect(connection.tables_only).to match_array %w[t1 t2] + ar_internal_tables
  end

  it "user_tables_only doesn't list internal tables" do
    expect(connection.user_tables_only).to match_array %w[t1 t2]
  end

end

# Only test ActiveRecord versions which support views (5.0+)
if ActiveRecord::Base.connection.respond_to? :views
  describe 'user_views_only' do
    let(:connection) { ActiveRecord::Base.connection }

    around(:each) do |example|
      create_dummy_data_sources &example
    end

    if DataSourceHelpers.is_postgresql?
      it 'lists all views and materialized views' do
        expect(connection.user_views_only).to match_array %w[v1 v2 mv1 mv2]
      end
    else
      it 'lists all views' do
        expect(connection.user_views_only).to match_array %w[v1 v2]
      end
    end
  end
end


if DataSourceHelpers.is_postgresql?
  describe '_pg_relations' do
    let(:connection) { ActiveRecord::Base.connection }

    around(:each) do |example|
      create_dummy_data_sources &example
    end

    it 'lists (r)elations (tables)' do
      result = (connection._pg_relations(%w[r]))
      expect(result).to include *%w[t1 t2]
      expect(result).not_to include *%w[v1 v2]
      expect(result).not_to include *%w[mv1 mv2]
    end

    it 'lists (v)iews' do
      result = (connection._pg_relations(%w[v]))
      expect(result).to include *%w[v1 v2]
      expect(result).not_to include *%w[mv1 mv2]
      expect(result).not_to include *%w[t1 t2]
    end

    it 'lists (m)aterialized views' do
      result = (connection._pg_relations(%w[m]))
      expect(result).to include *%w[mv1 mv2]
      expect(result).not_to include *%w[v1 v2]
      expect(result).not_to include *%w[t1 t2]
    end

    it 'lists (r)elations and (v)iews' do
      result = (connection._pg_relations(%w[r v]))
      expect(result).to include *%w[t1 t2 v1 v2]
      expect(result).not_to include *%w[mv1 mv2]
    end

    it 'lists (r)elations, (v)iews and (m)aterialized views' do
      result = (connection._pg_relations(%w[r v m]))
      expect(result).to include *%w[t1 t2 v1 v2 mv1 mv2]
    end

    it 'supports extra SQL code' do
      result = (connection._pg_relations(%w[r v m], "AND c.relname NOT LIKE '%2'"))
      expect(result).to include *%w[t1 v1 mv1]
      expect(result).not_to include *%w[t2 v2 mv2]
    end
  end
end
