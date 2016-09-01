# encoding: utf-8
require 'spec_helper'

describe ActiveRecord::Migration do

  let(:connection) { ActiveRecord::Base.connection }

  it "does not create deprecation" do
    begin
      save_behavior = ActiveSupport::Deprecation.behavior
      ActiveSupport::Deprecation.behavior = :raise
      expect { 
        Class.new ActiveRecord::Migration.latest_version do
          define_method(:up) do
            create_table :foo
          end
        end
      }.not_to raise_error
    ensure
      ActiveSupport::Deprecation.behavior = save_behavior
    end
  end

  it "works with the latest migration object version" do
    ActiveRecord::Migration.suppress_messages do
      begin
        migration = Class.new ::ActiveRecord::Migration.latest_version do
          create_table :newtable, :force => true
        end
        migration.migrate(:up)
        expect(connection.tables_without_deprecation).to include 'newtable'
      ensure
        connection.drop_table :newtable, if_exists: true
      end
    end
  end
end
