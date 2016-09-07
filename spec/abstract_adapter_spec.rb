# encoding: utf-8
require 'spec_helper'
require_relative 'support/views'

SchemaMonkey.register ViewSupport

describe ActiveRecord::ConnectionAdapters::AbstractAdapter do

  context "tables_without_deprecation" do

    let(:connection) { ActiveRecord::Base.connection }

    around(:each) do |example|
      begin
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
      connection.tables_without_deprecation
    end

    it "lists all tables" do
      expect(connection.tables_without_deprecation).to match_array %w{t1 t2}
    end
  end
end

