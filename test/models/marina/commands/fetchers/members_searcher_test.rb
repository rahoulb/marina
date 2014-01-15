require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/fetchers/members_searcher'

describe Marina::Commands::Fetchers::MembersSearcher do
  subject { Marina::Commands::Fetchers::MembersSearcher.new user: user, data_store: data_store, field_definitions: field_definitions }

  it "does not require any special permissions" do
    subject.permission.must_equal nil
  end

  describe "when not logged in" do
    before do
      subject.user = nil
      data_store.expects(:by_visibility).with('all').returns(members)
    end

    it "finds members by their last_name" do
      members.expects(:by_last_name).with('Patel').returns(members)

      results = nil
      subject.fetch last_name: 'Patel' do | found |
        results = found
      end
      results.must_equal members
    end

    it "finds members by multi-select fields" do
      first_field.expects(:matches).with(first_member, 'this, that').returns(true)
      second_field.expects(:matches).with(first_member, 'whatever').returns(true)

      first_field.expects(:matches).with(second_member, 'this, that').returns(true)
      second_field.expects(:matches).with(second_member, 'whatever').returns(false)

      results = nil
      subject.fetch first: 'this, that', second: 'whatever' do | found |
        results = found
      end
      results.must_equal [first_member]
    end
  end

  let(:user) { mock 'User' }
  let(:data_store) { mock 'Marina::Db::Members' }
  let(:members) { [first_member, second_member] }
  let(:first_member) { mock 'Marina::Db::Member' }
  let(:second_member) { mock 'Marina::Db::Member' }
  let(:field_definitions) { [first_field, second_field] }
  let(:first_field) { stub 'FieldDefinition', name: 'first' }
  let(:second_field) { stub 'FieldDefinition', name: 'second' }
end
