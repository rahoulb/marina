require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../app/models/marina/commands/builder'

describe Marina::Commands::Builder do
  subject { Marina::Commands::Builder.new data_store: data_store }

  before do 
    subject.stubs(:do_create).returns(:new_item)
  end

  describe "when the builder has permission" do
    before { subject.stubs(:check_security!).returns(true) }
    let(:item) { mock 'Item' }

    it "builds an item" do
      results = nil
      subject.build_from params do | created |
        results = created
      end
      results.must_equal :new_item
    end

    it "updates an existing item" do
      item.expects(:update_attributes!).with(params).returns(true)

      results = nil
      subject.update item, params do | updated |
        results = updated
      end
      results.must_equal item
    end

    it "updates an existing item when given a numeric id" do
      data_store.expects(:find).with(123).returns(item)
      item.expects(:update_attributes!).with(params).returns(true)

      results = nil
      subject.update 123, params do | updated |
        results = updated
      end
      results.must_equal item
    end

    it "updates an existing item when given a string id" do
      data_store.expects(:find).with('123').returns(item)
      item.expects(:update_attributes!).with(params).returns(true)

      results = nil
      subject.update '123', params do | updated |
        results = updated
      end
      results.must_equal item
    end

  end

  describe "when the fetcher does not have permission" do
    before { subject.stubs(:check_security!).raises(Marina::Commands::Unauthorised) }

    it "is not allowed to build an item" do
      begin
        subject.build_from params
        flunk
      rescue Marina::Commands::Unauthorised
        # expected
      end
    end
    
    it "is not allowed to update an item" do
      begin
        subject.update 123, params
        flunk
      rescue Marina::Commands::Unauthorised
        # expected
      end
    end

  end

  let(:params) { { some: 'params' } }
  let(:data_store) { stub }
end
