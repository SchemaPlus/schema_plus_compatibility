# encoding: utf-8
require 'spec_helper'

describe ActiveRecord::Migration do
  before(:each) do
    define_schema do
      create_table :users, :force => true do |t|
        t.string :bla
      end

      create_table :posts, :force => true do |t|
        t.string :content
      end
    end

    class Post < ::ActiveRecord::Base ; end
    @model = Post
  end

  it "should support the latest migration object version" do
    migration = Class.new ::ActiveRecord::Migration.latest_version do
      create_table :orders, :force => true do |t|
        t.string :bar
      end
    end
    ActiveRecord::Migration.suppress_messages do
      migration.migrate(:up)
    end
    expect(@model.connection.tables).to include 'orders'
  end
end
