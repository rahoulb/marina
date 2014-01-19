require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/fetchers/latest_members_fetcher'
require_relative '../../../../support/object_extensions'

describe Marina::Commands::Fetchers::LatestMembersFetcher do
  subject { Marina::Commands::Fetchers::LatestMembersFetcher.new user: user, data_store: data_store }

  it "does not require any special permissions" do
    subject.permission.must_equal nil
  end

  describe "when not logged in" do
    before { subject.user = nil }

    it "finds the latest members with their privacy set to none" do
      data_store.expects(:visible_to_all).returns(members)
      members.expects(:latest_members).with(5).returns(members)

      results = nil
      subject.fetch count: 5 do | found |
        results = found
      end
      results.must_equal members
    end
  end

  describe "when the user is a member with no active subscription" do
    before do
      user.stubs(:can).with(:access_all_members).returns(false)
      user.stubs(:current_subscription_plan).returns(nil)
    end

    it "finds the latest members with their privacy set to none" do
      data_store.expects(:visible_to_all).returns(members)
      members.expects(:latest_members).with(5).returns(members)

      results = nil
      subject.fetch count: 5 do | found |
        results = found
      end
      results.must_equal members
    end
  end

  describe "when the user is a member" do
    before do 
      user.stubs(:can).with(:access_all_members).returns(false)
      user.stubs(:current_subscription_plan).returns(standard_plan)
    end

    it "finds the latest members with their privacy set to none or some with the given plan" do
      data_store.expects(:all_latest_members).returns(all_members)
      
      results = nil
      subject.fetch count: 5 do | found |
        results = found
      end
      results.size.must_equal 2
      results.include?(included_1).must_equal true
      results.include?(included_2).must_equal true
    end

    let(:all_members) { [included_1, included_2, excluded_1, excluded_2] }
    let(:included_1) { stub 'Member', visible_to: 'all' }
    let(:included_2) { stub 'Member', visible_to: 'some', visible_plans: [123, 456] }
    let(:excluded_1) { stub 'Member', visible_to: 'some', visible_plans: [456] }
    let(:excluded_2) { stub 'Member', visible_to: 'none' }
  end

  describe "when the user has all access" do
    before do 
      user.stubs(:can).with(:access_all_members).returns(true)
      user.stubs(:current_subscription_plan).returns(standard_plan)
    end

    it "finds the latest members with their privacy set to none" do
      data_store.expects(:latest_members).with(5).returns(members)

      results = nil
      subject.fetch count: 5 do | found |
        results = found
      end
      results.must_equal members
    end
  end

  let(:user) { stub 'User' }
  let(:data_store) { stub 'Marina::Db::Members' }
  let(:members) { [stub('member'), stub('member')] }
  let(:standard_plan) { stub 'SubscriptionPlan', id: 123 }
end
