# encoding: utf-8
require 'spec_helper'

describe ActiveRecord::ConnectionAdapters::AbstractAdapter do
  context "when there are multiple tables" do
    before(:each) do
      define_schema do
        create_table :users, :force => true do |t|
          t.string :bla
        end

        create_table :members, :force => true do |t|
          t.string :foo
        end

        create_table :comments, :force => true do |t|
          t.string :bar
        end

        create_table :posts, :force => true do |t|
          t.string :content
        end
      end

      class Post < ::ActiveRecord::Base ; end
      @model = Post
    end

    it "should support listing tables without deprecation warnings" do
      # Ignore this table which only exists on AR5.0
      tables = @model.connection.tables - ['ar_internal_metadata']
      expect(tables).to match_array %w{users members comments posts}
    end
  end
end

