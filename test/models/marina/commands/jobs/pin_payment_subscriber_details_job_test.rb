require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/jobs/pin_payment_subscriber_details_job'

describe Marina::Commands::Jobs::PinPaymentSubscriberDetailsJob do
  subject { Marina::Commands::Jobs::PinPaymentSubscriberDetailsJob.new 123 }

  before do
    subject.stubs(:payment_processor).returns(payment_processor)
    subject.stubs(:member).returns(member)
    subject.stubs(:plan_by_feature_level).with('PREMIUM').returns(plan)
    payment_processor.expects(:get_subscriber_details).with(123).returns(subscriber_details)
    subscription.expects(:update_attributes!).with(active: true, expires_on: (Date.today + 365), plan: plan, lifetime_subscription: false, credit: 0.0, identifier: 'George-Testington')
    subject.expects(:log_transaction_for).with(member)
  end

  describe "when the member has a current subscription" do
    before do
      member.stubs(:current_subscription).returns(subscription)
    end

    it "is updated" do
      subject.perform
    end
  end

  describe "when the member does not have a current subscription" do
    before do
      member.stubs(:current_subscription).returns(nil)
    end

    it "is created" do
      member.expects(:build_subscription).returns(subscription)

      subject.perform
    end
  end

  let(:payment_processor) { mock 'Payment Processor' }
  let(:subscriber_details) { stub active: true, active_until: (Date.today + 365), feature_level: 'PREMIUM', lifetime_subscription: false, credit: 0.0, identifier: 'George-Testington' }
  let(:member) { mock 'Member' }
  let(:subscription) { mock 'Subscription' }
  let(:plan) { mock 'Plan' }
end
