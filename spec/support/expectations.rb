def expect_not_deprecated(&block)
  begin
    save_behavior = ActiveSupport::Deprecation.behavior
    ActiveSupport::Deprecation.behavior = :raise
    expect { yield }.not_to raise_error
  ensure
    ActiveSupport::Deprecation.behavior = save_behavior
  end
end
