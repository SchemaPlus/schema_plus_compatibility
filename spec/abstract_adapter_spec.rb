# encoding: utf-8
require 'spec_helper'
require_relative 'support/views'

SchemaMonkey.register ViewSupport

RSpec.shared_examples 'tables_only_tests' do
  it "does not cause deprecation" do
    expect(ActiveSupport::Deprecation).not_to receive(:warn)
    connection.tables_only
  end

  it "lists all tables" do
    expect(connection.tables_only).to match_array %w[t1 t2]
  end

end


describe ActiveRecord::ConnectionAdapters::AbstractAdapter do
  context "tables_only" do
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

    include_examples 'tables_only_tests'
  end

  context "tables_only with AR5-style custom adapter" do
    class AR5CustomAdapter < ActiveRecord::ConnectionAdapters::AbstractAdapter
      def initialize
        super nil
      end

      def tables
        raise NotImplementedError
      end

      def data_sources
        %w[t1 t2 v1 v2]
      end

      def views
        %w[v1 v2]
      end
    end

    let(:connection) { AR5CustomAdapter.new }

    include_examples 'tables_only_tests'
  end

  if ActiveRecord::VERSION::MAJOR < 5
    context "tables_only with AR4.2 custom adapter with views" do
      class AR4CustomAdapterWithViews < ActiveRecord::ConnectionAdapters::AbstractAdapter
        def initialize
          super nil
        end

        def tables
          %w[t1 t2 v1 v2]
        end

        def views
          %w[v1 v2]
        end
      end

      let(:connection) { AR4CustomAdapterWithViews.new }

      include_examples 'tables_only_tests'
    end

    context "tables_only with AR4.2 custom adapter" do
      class AR4CustomAdapter < ActiveRecord::ConnectionAdapters::AbstractAdapter
        def initialize
          super nil
        end

        def tables
          # Only consistent if adapter doesn't list views even though it has no notion of them.
          %w[t1 t2]
        end
      end

      let(:connection) { AR4CustomAdapter.new }

      include_examples 'tables_only_tests'
    end
  end
end

