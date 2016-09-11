# encoding: utf-8
require 'spec_helper'
require_relative 'support/views'

SchemaMonkey.register ViewSupport

describe "tables_only" do
  let(:connection) { ActiveRecord::Base.connection }

  around(:each) do |example|
    begin
      connection.tables_only.each do |table|
        connection.drop_table table, force: :cascade
      end
      connection.create_table :t1, force: true
      connection.create_table :t2, force: true
      connection.create_dummy_view :v1
      connection.create_dummy_view :v2
      example.run
    ensure
      connection.drop_table :t1, if_exists: true
      connection.drop_table :t2, if_exists: true
      connection.drop_dummy_view :v1
      connection.drop_dummy_view :v2
    end
  end

  it "does not cause deprecation" do
    expect(ActiveSupport::Deprecation).not_to receive(:warn)
    connection.tables_only
  end

  it "lists all tables" do
    t = connection.tables_only

    # Tables may include ar_internal_metadata on AR5
    if t.include? "ar_internal_metadata"
      expect(connection.tables_only).to match_array %w[t1 t2 ar_internal_metadata]
    else
      expect(connection.tables_only).to match_array %w[t1 t2]
    end
  end

  it "user_tables_only doesn't list internal tables" do
    # user_tables_only shouldn't return ar_internal_metadata
    expect(connection.user_tables_only).to match_array %w[t1 t2]
  end
end
