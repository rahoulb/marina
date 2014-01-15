require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/fetchers/members_searcher'

describe Marina::Commands::Fetchers::MembersSearcher do
  subject { Marina::Commands::Fetchers::MembersSearcher.new user: user, data_store: data_store }

  it "does not require any special permissions" do
    subject.permission.must_equal nil
  end

  describe "when not logged in" do
    before { subject.user = nil }

    it "finds members by their last_name" do
      data_store.expects(:by_visibility).with('all').returns(data_store)
      data_store.expects(:by_last_name).with('Patel').returns(members)

      results = nil
      subject.fetch last_name: 'Patel' do | found |
        results = found
      end
      results.must_equal members
    end
  end

  let(:user) { mock 'User' }
  let(:data_store) { mock 'Marina::Db::Members' }
  let(:members) { [mock('member'), mock('member')] }
end
