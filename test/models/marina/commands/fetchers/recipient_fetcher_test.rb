require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/fetchers/recipient_fetcher'

describe Marina::Commands::Fetchers::RecipientFetcher do
  subject { Marina::Commands::Fetchers::RecipientFetcher.new user: user, mailout: mailout } 

  describe "when doing a test send" do
    let(:mailout) { stub test: true, send_to_all_members: false, recipient_plan_ids: nil }

    it "lists the user as the only recipient" do
      result = nil
      subject.fetch do | found |
        result = found
      end
      result.must_equal [user]
    end
  end

  describe "when sending to a subset of the plans" do
    let(:mailout) { stub test: false, send_to_all_members: false, recipient_plan_ids: [1, 2] }

    it "lists the members of the given plans" do
      subject.expects(:plan).with(1).returns(first_plan)
      subject.expects(:plan).with(2).returns(second_plan)

      result = nil
      subject.fetch do | found |
        result = found
      end
      result.must_equal first_plan.members + second_plan.members
    end
  end

  describe "when sending to all members" do
    let(:mailout) { stub test: false, send_to_all_members: true, recipient_plan_ids: nil }

    it "lists the members of all plans" do
      subject.expects(:all_plans).returns(all_plans)

      result = nil
      subject.fetch do | found |
        result = found
      end
      result.must_equal first_plan.members + second_plan.members
    end

  end

  let(:user) { mock 'User' }
  let(:all_plans) { [first_plan, second_plan] }
  let(:first_plan) { stub 'Plan', members: first_plan_members }
  let(:second_plan) { stub 'Plan', members: second_plan_members }
  let(:first_plan_members) { [mock('Member'), mock('Member')] }
  let(:second_plan_members) { [mock('Member')] }

end
