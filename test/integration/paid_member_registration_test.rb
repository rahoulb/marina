require_relative "../test_helper"

# To be handled correctly this spec must end with "Integration Test"
describe "PaidMemberRegistration Integration Test" do

  describe "when given valid details" do
    before do
      Rails.application.config.mailing_list_processor = mailing_list_processor
      Rails.application.config.payment_processor = payment_processor
    end

    it "creates the record and informs the mailing list and payment processors" do
      send_registration_request
      verify_member_created
      receive_payment_notification_from_pin_payments
      verify_subscription_added
      verify_transaction_logged
    end

    def send_registration_request
      mailing_list_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan_name' => 'Premium')
      payment_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan' => plan)

      post api_members_path, member: params, format: 'json'
    end

    def verify_member_created
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

    def receive_payment_notification_from_pin_payments
      post '/api/pin_payment_notifications', subscriber_ids: [@member.id]
      response.status.must_equal 200

      payment_processor.expects(:get_subscriber_details).with(@member.id.to_s).returns(subscriber_details)
      Delayed::Worker.new.work_off

      @member.reload
    end

    def verify_subscription_added
      @subscription = @member.current_subscription
      @subscription.wont_equal nil
      @subscription.active.must_equal true
      @subscription.expires_on.must_equal subscriber_details.active_until
      @subscription.plan.must_equal plan
      @subscription.lifetime_subscription.must_equal subscriber_details.lifetime_subscription
      @subscription.credit.must_equal subscriber_details.credit
      @subscription.identifier.must_equal subscriber_details.identifier

      @member.reload
      @member.has_directory_listing.must_equal true
    end

    def verify_transaction_logged
      @log_entry = @member.log_entries.first
      @log_entry.kind_of?(Marina::Db::LogEntry::Transaction).must_equal true
    end

    let(:mailing_list_processor) { mock 'Mailing List Processor' }
    let(:payment_processor) { mock 'Payment Processor' }
    let(:subscriber_details) { stub active: true, active_until: (Date.today + 365), feature_level: 'PREMIUM', lifetime_subscription: false, credit: 0.0, identifier: 'George-Testington' }
  end
  
  describe "when given invalid details" do
    it "returns an error message" do
      post api_members_path, member: params.merge(last_name: ''), format: 'json'

      response.status.must_equal 422
    end
  end

  let(:plan) { a_saved Marina::Db::Subscription::PaidPlan, name: 'Premium', feature_levels: ['PREMIUM'], has_directory_listing: true }
  let(:params) { { first_name: 'George', last_name: 'Testington', email: 'george@example.com', username: 'georgiou', password: 'secret101', password_confirmation: 'secret101', agrees_to_terms: true, receives_mailshots: false, subscription_plan_id: plan.id } }

end
