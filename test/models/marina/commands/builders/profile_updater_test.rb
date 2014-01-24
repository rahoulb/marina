require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/builders/profile_updater'

describe Marina::Commands::Builders::ProfileUpdater do
  subject { Marina::Commands::Builders::ProfileUpdater.new user: user, data_store: data_store }

  describe "when not logged in" do
    before { subject.user = nil }

    it "is not allowed" do
      begin
        subject.update user, params
      rescue Marina::Commands::Unauthorised
        # expected
      end
    end
  end

  describe "when logged in as a basic member" do
    before { user.stubs(:current_subscription).returns(nil) }

    it "only allows updates to basic fields" do
      user.expects(:update_attributes!).with(basic_fields).returns(true)
      result = nil
      subject.update user, params do | updated |
        result = updated
      end
      result.must_equal user
    end

    it "does not allow updates to anyone other that yourself" do
      begin
        subject.update member, params
      rescue Marina::Commands::Unauthorised
        # expected
      end
    end
  end

  describe "when logged in as a plan member" do
    before { user.stubs(:current_subscription).returns(plan) }

    it "allows updates to all fields" do
      user.expects(:update_attributes!).with(params).returns(true)
      result = nil
      subject.update user, params do | updated |
        result = updated
      end
      result.must_equal user
    end

    it "does not allow updates to anyone other that yourself" do
      begin
        subject.update member, params
      rescue Marina::Commands::Unauthorised
        # expected
      end
    end
    let(:plan) { stub 'Plan' }
  end

  let(:user) { stub 'User' }
  let(:member) { stub 'Member' }
  let(:data_store) { stub 'DataStore' }
  let(:basic_fields) { { username: 'username', password: 'password', password_confirmation: 'password', title: 'title', email: 'email', first_name: 'firstname', last_name: 'lastname' } } 
  let(:standard_fields) { { biography: 'biography', address: 'address', town: 'town', county: 'county', postcode: 'postcode', country: 'England', telephone: 'telephone', web_address: 'webaddress' } }
  let(:params) { basic_fields.merge(standard_fields) }
end
