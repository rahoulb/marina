require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/builders/member_builder'

describe Marina::Commands::Builders::MemberBuilder do
  subject { Marina::Commands::Builders::MemberBuilder.new user: user, data_store: data_store, subscription_plans_store: plans_store, payment_processor: nil, mailing_list_processor: nil }

  it "requires no special permissions" do
    subject.permission.must_equal nil
  end

  describe "when creating a member" do
    before do
      data_store.expects(:create!).returns(member)
      plans_store.expects(:find).with(123).returns(plan)
    end

    it "attaches the member to the given subscription plan" do
      member.expects(:subscribe_to).with(plan)

      result = nil
      subject.build_from params do | member |
        result = member
      end
      result.must_equal member
    end

    it "notifies the payment processor" do
      member.stubs(:subscribe_to)
      subject.payment_processor = payment_processor

      payment_processor.expects(:new_subscriber).with(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], plan_name: plan.name)

      subject.build_from(params) { | member | member }
    end

    it "notifies the mailing list processor" do
      member.stubs(:subscribe_to)
      subject.mailing_list_processor = mailing_list_processor

      mailing_list_processor.expects(:new_subscriber).with(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], plan_name: plan.name)

      subject.build_from(params) { | member | member }
    end
  end

  let(:user) { mock 'User' }
  let(:data_store) { mock 'Members' }
  let(:plans_store) { mock 'Subscription::Plans' }
  let(:plan) { stub 'Plan', id: 123, name: 'Some plan' }
  let(:member) { mock 'Member' }
  let(:params) {  { first_name: 'George', last_name: 'Testington', email: 'george@example.com', username: 'georgiou', password: 'secret101', password_confirmation: 'secret101', agrees_to_terms: true, receives_mailshots: false, subscription_plan_id: plan.id} }
  let(:payment_processor) { mock 'Payment processor' }
  let(:mailing_list_processor) { mock 'Mailing list processor' }
end
