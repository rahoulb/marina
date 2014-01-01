require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/fetchers/authenticator'

describe Marina::Commands::Fetchers::Authenticator do
  subject { Marina::Commands::Fetchers::Authenticator.new members: members }

  describe "when the username is not found" do
    before { members.expects(:by_username).with('test101').returns(nil) }

    it "raises an authentication error" do
      begin
        subject.authenticate 'test101', 'secret'
        flunk
      rescue Marina::Commands::Unauthorised
        # expected
      end
    end
  end

  describe "when the wrong password is given" do
    before { members.expects(:by_username).with('test101').returns(member) }

    it "raises an authentication error" do
      member.expects(:verify_password).with('secret').returns(false)
      begin
        subject.authenticate 'test101', 'secret'
        flunk
      rescue Marina::Commands::Unauthorised
        # expected
      end
    end
  end

  describe "when valid credentials are given" do
    before { members.expects(:by_username).with('test101').returns(member) }

    it "returns the member" do
      member.expects(:verify_password).with('secret').returns(true)

      result = nil
      subject.authenticate('test101', 'secret') do | m |
        result = m
      end
      result.must_equal member
    end

  end

  let(:members) { mock 'Marina::Db::Members' }
  let(:member) { mock 'Marina::Db::Member' }
end
