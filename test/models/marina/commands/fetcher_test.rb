require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../app/models/marina/commands/fetcher'

describe Marina::Commands::Fetcher do
  subject { Marina::Commands::Fetcher.new user: user }

  before { subject.stubs(:do_fetch).returns(:data) }

  describe "when the fetcher does not require any permissions" do
    before { subject.permission = nil }

    describe "and no-one is logged in" do
      before { subject.user = nil }

      it "fetches the data" do
        results = nil
        subject.fetch do | found |
          results = found
        end
        results.must_equal :data
      end
    end

    describe "and someone is logged in" do
      it "fetches the data" do
        results = nil
        subject.fetch do | found |
          results = found
        end
        results.must_equal :data
      end
    end
  end

  describe "when the fetcher requires a particular permission" do
    before { subject.permission = :do_something }

    describe "and no-one is logged in" do
      before { subject.user = nil }

      it "is not allowed" do
        begin
          subject.fetch
          flunk
        rescue Marina::Commands::Unauthorised
          # expected
        end
      end

    end

    describe "and someone is logged in" do
      describe "with the relevant permission" do
        before { user.stubs(:can).with(:do_something).returns(true) }

        it "fetches the data" do
          results = nil
          subject.fetch do | found |
            results = found
          end
          results.must_equal :data
        end
      end

      describe "without the relevant permission" do
        before { user.stubs(:can).with(:do_something).returns(false) }

        it "is not allowed" do
          begin
            subject.fetch
            flunk
          rescue Marina::Commands::Unauthorised
            # expected
          end
        end
      end
    end
  end

  let(:user) { mock 'User' }
end
