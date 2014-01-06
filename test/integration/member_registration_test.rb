require_relative '../test_helper'

describe "MemberRegistration Integration Test" do

  describe "creating a member on a basic plan" do
    before do
      @plan = a_saved Marina::Db::Subscription::BasicPlan, name: 'Basic Plan'
    end

    describe "when given valid details" do
      before do
        Rails.application.config.mailing_list_processor = nil
        Rails.application.config.payment_processor = nil
      end

      it "creates the member record" do
        post api_members_path, member: params, format: 'json'

        response.status.must_equal 201
        @member = Marina::Db::Member.by_username 'georgiou'
        @member.wont_equal nil
        @member.first_name.must_equal 'George'
        @member.last_name.must_equal 'Testington'
        @member.email.must_equal 'george@example.com'
        @subscription = @member.current_subscription
        @subscription.wont_equal nil
        @subscription.active.must_equal true
        @subscription.plan.must_equal @plan
      end

      it "registers the member with the mailing list processor" do
        Rails.application.config.mailing_list_processor = mailing_list_processor

        mailing_list_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan_name' => 'Basic Plan')

        post api_members_path, member: params, format: 'json'
      end

      it "registers the member with the payment processor" do
        Rails.application.config.payment_processor = payment_processor

        payment_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan_name' => 'Basic Plan')

        post api_members_path, member: params, format: 'json'
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

    let(:params) { { first_name: 'George', last_name: 'Testington', email: 'george@example.com', username: 'georgiou', password: 'secret101', password_confirmation: 'secret101', agrees_to_terms: true, receives_mailshots: false, subscription_plan_id: @plan.id } }
  end

end
