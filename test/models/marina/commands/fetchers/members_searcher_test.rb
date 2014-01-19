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
      data_store.expects(:visible_to_all).returns(members)
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

  describe "when logged in as a member with no active subscription" do
    before do
      user.stubs(:can).with(:access_all_members).returns(false)
      user.stubs(:current_subscription_plan).returns(nil)
      data_store.expects(:visible_to_all).returns(members)
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

  describe "when logged in as a member with a subscription" do
    before do
      user.stubs(:can).with(:access_all_members).returns(false)
      user.stubs(:current_subscription_plan).returns(subscription_plan)
      data_store.expects(:visible_to_members).returns(members)
    end

    it "finds members by their last_name" do
      members.expects(:by_last_name).with('Patel').returns(members)

      results = nil
      subject.fetch last_name: 'Patel' do | found |
        results = found
      end
      results.must_equal [first_member]
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

    let(:subscription_plan) { stub 'Plan', id: 123 }
  end

  describe "when logged in with full access" do
    before do
      user.stubs(:can).with(:access_all_members).returns(true)
      user.stubs(:current_subscription_plan).returns(nil)
      data_store.expects(:all).returns(members)
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

  let(:user) { stub 'User' }
  let(:data_store) { stub 'Marina::Db::Members' }
  let(:members) { [first_member, second_member] }
  let(:first_member) { stub 'Marina::Db::Member', visible_to: 'some', visible_plans: [123] }
  let(:second_member) { stub 'Marina::Db::Member', visible_to: 'some', visible_plans: [456] }
  let(:field_definitions) { [first_field, second_field] }
  let(:first_field) { stub 'FieldDefinition', name: 'first' }
  let(:second_field) { stub 'FieldDefinition', name: 'second' }
end
