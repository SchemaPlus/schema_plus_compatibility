# encoding: utf-8
require 'spec_helper'

describe ActiveRecord::Migration do

  let (:latest) {
    if Gem::Requirement.new("~> 5.0.0").satisfied_by?(::ActiveRecord.version)
      ActiveRecord::Migration[5.0]
    elsif Gem::Requirement.new("~> 4.2.0").satisfied_by?(::ActiveRecord.version)
      ActiveRecord::Migration
    end
  }

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

  it "returns latest migration version" do
    expect(ActiveRecord::Migration.latest_version).to eq latest
  end

end
