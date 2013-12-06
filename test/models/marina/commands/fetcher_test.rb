require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../app/models/marina/commands/fetcher'

describe Marina::Commands::Fetcher do
  subject { Marina::Commands::Fetcher.new }

  before { subject.stubs(:do_fetch).returns(:data) }

  describe "when the fetcher has permission" do
    before { subject.stubs(:check_security!).returns(true) }

    it "fetches the data" do
      results = nil
      subject.fetch do | found |
        results = found
      end
      results.must_equal :data
    end
  end

  describe "when the fetcher does not have permission" do
    before { subject.stubs(:check_security!).raises(Marina::Commands::Unauthorised) }

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
