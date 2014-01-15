require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/fetchers/latest_members_fetcher'

describe Marina::Commands::Fetchers::LatestMembersFetcher do
  subject { Marina::Commands::Fetchers::LatestMembersFetcher.new user: user, data_store: data_store }

  it "does not require any special permissions" do
    subject.permission.must_equal nil
  end

  describe "when not logged in" do
    before { subject.user = nil }

    it "finds the latest members with their privacy set to none" do
      data_store.expects(:by_visibility).with('all').returns(members)
      members.expects(:latest_members).with(5).returns(members)

      results = nil
      subject.fetch count: 5 do | found |
        results = found
      end
      results.must_equal members
    end
  end

  describe "when the user has all access" do
    before { user.stubs(:can).with(:access_all_members).returns(true) }

    it "finds the latest members with their privacy set to none" do
      data_store.expects(:latest_members).with(5).returns(members)

      results = nil
      subject.fetch count: 5 do | found |
        results = found
      end
      results.must_equal members
    end
  end

  let(:user) { mock 'User' }
  let(:data_store) { mock 'Marina::Db::Members' }
  let(:members) { [mock('member'), mock('member')] }
end
