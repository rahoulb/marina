require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../app/models/marina/commands/subscription_plans'

describe Marina::Commands::SubscriptionPlans do
  subject { Marina::Commands::SubscriptionPlans.new }

  it "requires the :list_subscription_plans permission" do
    subject.permission.must_equal :list_subscription_plans
  end

end
