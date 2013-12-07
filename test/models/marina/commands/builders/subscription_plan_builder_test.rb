require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/builders/subscription_plan_builder'

describe Marina::Commands::Builders::SubscriptionPlanBuilder do
  subject { Marina::Commands::Builders::SubscriptionPlanBuilder.new }

  it "requires the :add_subscription_plan permission" do
    subject.permission.must_equal :add_subscription_plans
  end
end
