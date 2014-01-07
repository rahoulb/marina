require_relative '../test_helper'

describe "MemberRegistration Integration Test" do

  describe "when given valid details" do
    before do
      Rails.application.config.mailing_list_processor = mailing_list_processor
      Rails.application.config.payment_processor = payment_processor
    end

    it "creates the record and informs the mailing list and payment processors" do
      mailing_list_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan_name' => nil)
      payment_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan' => nil)

      post api_members_path, member: params, format: 'json'

      response.status.must_equal 201
      @member = Marina::Db::Member.by_username 'georgiou'
      @member.wont_equal nil
      @member.first_name.must_equal 'George'
      @member.last_name.must_equal 'Testington'
      @member.email.must_equal 'george@example.com'
      @member.receives_mailshots.must_equal false
      @member.current_subscription.must_equal nil
      @member.log_entries.first.kind_of?(Marina::Db::LogEntry::Registration).must_equal true
    end

    let(:mailing_list_processor) { mock 'Mailing List Processor' }
    let(:payment_processor) { mock 'Payment Processor' }
  end
  
  describe "when given invalid details" do
    it "returns an error message" do
      post api_members_path, member: params.merge(last_name: ''), format: 'json'

      response.status.must_equal 422
    end
  end

  let(:params) { { first_name: 'George', last_name: 'Testington', email: 'george@example.com', username: 'georgiou', password: 'secret101', password_confirmation: 'secret101', agrees_to_terms: true, receives_mailshots: false } }

end
