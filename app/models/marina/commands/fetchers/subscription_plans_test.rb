require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/fetchers/subscription_plans'

describe Marina::Commands::Fetchers::SubscriptionPlans do
  subject { Marina::Commands::Fetchers::SubscriptionPlans.new }

  it "requires the :list_subscription_plans permission" do
    subject.permission.must_equal :list_subscription_plans
  end

end
