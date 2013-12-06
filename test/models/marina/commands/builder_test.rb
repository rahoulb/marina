require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../app/models/marina/commands/builder'

describe Marina::Commands::Builder do
  subject { Marina::Commands::Builder.new }

  before { subject.stubs(:do_create).returns(:new_item) }

  describe "when the builder has permission" do
    before { subject.stubs(:check_security!).returns(true) }

    it "builds an item" do
      results = nil
      subject.build_from params do | created |
        results = created
      end
      results.must_equal :new_item
    end
  end

  describe "when the fetcher does not have permission" do
    before { subject.stubs(:check_security!).raises(Marina::Commands::Unauthorised) }

    it "is not allowed" do
      begin
        subject.build_from params
        flunk
      rescue Marina::Commands::Unauthorised
        # expected
      end
    end
  end

  let(:params) { { some: 'params' } }
end
