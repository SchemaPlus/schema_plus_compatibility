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

  it "returns latest migration version" do
    expect(ActiveRecord::Migration.latest_version).to eq latest
  end

end
