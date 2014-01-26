require_relative "../test_helper"

describe "VisitorRegistersOnApprovedPlan Integration Test" do
  before do
    given_a_payment_processor_and_mailing_list_processor
  end

  it "registers successfully and is approved" do
    when_i_register
    then_i_should_become_a_basic_member_with_an_application_for_the_approved_plan
    when_my_application_is_accepted
    then_i_should_receive_an_email_with_payment_details
    when_my_payment_notification_is_received
    then_i_should_become_an_approved_member
    then_my_transaction_should_be_logged
  end

  it "registers unsuccessfully" do
    when_i_register_with_invalid_details
    then_my_registration_should_be_refused
  end

  it "registers with an auto-approval code" do
    given_an_auto_approval_code_has_been_configured
    when_i_register_with_an_auto_approval_code
    then_the_application_should_be_auto_approved
    when_my_payment_notification_is_received
    then_i_should_become_an_approved_member
    then_my_transaction_should_be_logged
  end

  it "registers successfully with an affiliated membership and is approved" do
    given_some_affiliated_organisations
    when_i_register_with_membership_of_an_affiliated_organisation
    then_i_should_become_a_basic_member_with_an_application_for_the_approved_plan
    when_my_affiliated_application_is_accepted
    then_i_should_receive_a_discount
    then_i_should_receive_an_email_with_payment_details
    when_my_payment_notification_is_received
    then_i_should_become_an_approved_member
    then_my_transaction_should_be_logged
  end

  it "registers successfully and is approved but the affiliated membership is rejected" do
    given_some_affiliated_organisations
    when_i_register_with_membership_of_an_affiliated_organisation
    then_i_should_become_a_basic_member_with_an_application_for_the_approved_plan
    when_my_application_is_accepted_but_the_affiliation_rejected
    then_i_should_receive_an_email_with_payment_details
    when_my_payment_notification_is_received
    then_i_should_become_an_approved_member
    then_my_transaction_should_be_logged
  end

  it "registers successfully with a voucher for free time" do
    given_a_voucher_for_free_time
    when_i_register_with_a_free_time_voucher_code
    then_the_application_should_be_auto_approved
    then_i_should_have_a_number_of_free_days
    then_i_should_become_an_approved_member
    then_my_transaction_should_be_logged
  end

  it "registers successfully with a voucher for money off" do
    given_a_voucher_for_money_off
    when_i_register_with_a_money_off_voucher_code
    then_i_should_become_a_basic_member_with_an_application_for_the_approved_plan
    when_my_application_is_accepted
    then_i_should_receive_an_email_with_payment_details
    when_my_payment_notification_is_received
    then_i_should_become_an_approved_member
    then_my_transaction_should_be_logged

  end

  it "registers but is rejected" do
    when_i_register
    then_i_should_become_a_basic_member_with_an_application_for_the_approved_plan
    when_my_application_is_rejected
    then_i_should_receive_an_email_rejection_details
    then_i_should_remain_a_basic_member
  end

  def given_a_payment_processor_and_mailing_list_processor
    Marina::Application.config.mailing_list_processor = mailing_list_processor
    Marina::Application.config.payment_processor = payment_processor
  end

  def given_an_auto_approval_code_has_been_configured
    Marina::Application.config.auto_approval_code = 'FULLMEMBER'
  end

  def given_some_affiliated_organisations
    @affiliate_organisation = a_saved Marina::Db::AffiliateOrganisation, name: 'Affiliate', discount: 50.0, applies_to_memberships: true
  end
  
  def given_a_voucher_for_free_time
    @voucher = a_saved Marina::Db::Voucher::FreeTime, code: 'FREESTUFF', days: 10
  end

  def given_a_voucher_for_money_off
    @voucher = a_saved Marina::Db::Voucher::Credit, code: 'FREESTUFF', amount: 10.0
  end

  def when_i_register
    mailing_list_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan_name' => 'Gold')
    payment_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan' => plan)

    post "/api/members", member: params, format: 'json'
  end

  def when_i_register_with_membership_of_an_affiliated_organisation
    mailing_list_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan_name' => 'Gold')
    payment_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan' => plan)

    post "/api/members", member: params.merge(affiliate_organisation: 'Affiliate', affiliate_details: '123'), format: 'json'
  end

  def when_i_register_with_an_auto_approval_code
    mailing_list_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan_name' => 'Gold')
    payment_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan' => plan)

    post "/api/members", member: params.merge(auto_approval_code: 'FULLMEMBER'), format: 'json'
  end

  def when_i_register_with_a_free_time_voucher_code
    mailing_list_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan_name' => 'Gold')
    payment_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan' => plan)
    payment_processor.expects(:add_time_to)

    post "/api/members", member: params.merge(voucher_code: 'FREESTUFF'), format: 'json'
  end

  def when_i_register_with_a_money_off_voucher_code
    mailing_list_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan_name' => 'Gold')
    payment_processor.expects(:new_subscriber).with('email' => 'george@example.com', 'first_name' => 'George', 'last_name' => 'Testington', 'plan' => plan)
    payment_processor.expects(:apply_credit_to)

    post "/api/members", member: params.merge(voucher_code: 'FREESTUFF'), format: 'json'
  end

  def when_my_application_is_accepted
    mailing_list_processor.expects(:application_approved).with(@application, payment_processor)
    @application.accepted_by administrator, mail_processor: mailing_list_processor, payment_processor: payment_processor
    @application.reload
    @application.administrator.must_equal administrator
    @application.status.must_equal 'approved'
  end

  def when_my_affiliated_application_is_accepted
    payment_processor.expects(:apply_credit_to).with(@member, 50.0)
    when_my_application_is_accepted
  end

  def when_my_application_is_accepted_but_the_affiliation_rejected
    mailing_list_processor.expects(:application_approved).with(@application, payment_processor)
    @application.accepted_by administrator, mail_processor: mailing_list_processor, payment_processor: payment_processor, reason_for_affiliation_rejection: 'Wrong'
    @application.reload
    @application.administrator.must_equal administrator
    @application.status.must_equal 'approved'
  end

  def when_my_application_is_rejected 
    mailing_list_processor.expects(:application_rejected).with(@application)
    @application.rejected_by administrator, reason: 'You know nothing', mail_processor: mailing_list_processor
    @application.reload
    @application.administrator.must_equal administrator
    @application.status.must_equal 'rejected'
    @application.reason_for_rejection.must_equal 'You know nothing'
  end

  def when_i_register_with_invalid_details
    post "/api/members", member: params.slice(:first_name, :last_name, :subscription_plan_id), format: 'json'
  end

  def when_my_payment_notification_is_received
    post '/api/pin_payment_notifications', subscriber_ids: [@member.id]
    response.status.must_equal 200

    payment_processor.expects(:get_subscriber_details).with(@member.id.to_s).returns(subscriber_details)
    Delayed::Worker.new.work_off

    @member.reload
  end

  def then_i_should_become_an_approved_member
    @subscription = @member.current_subscription
    @subscription.wont_equal nil
    @subscription.active.must_equal true
    @subscription.expires_on.must_equal subscriber_details.active_until
    @subscription.plan.must_equal plan
    @subscription.lifetime_subscription.must_equal subscriber_details.lifetime_subscription
    @subscription.credit.must_equal subscriber_details.credit
    @subscription.identifier.must_equal subscriber_details.identifier
  end

  def then_my_transaction_should_be_logged
    @log_entry = @member.log_entries.first
    @log_entry.kind_of?(Marina::Db::LogEntry::Transaction).must_equal true
  end

  def then_i_should_receive_a_discount
    # dealt with by the expects on the payment processor
  end

  def then_i_should_have_a_number_of_free_days
    post '/api/pin_payment_notifications', subscriber_ids: [@member.id]
    response.status.must_equal 200

    payment_processor.expects(:get_subscriber_details).with(@member.id.to_s).returns(subscriber_details)
    Delayed::Worker.new.work_off

    @member.reload
  end

  def then_i_should_become_a_basic_member_with_an_application_for_the_approved_plan
    response.status.must_equal 201

    @member = Marina::Db::Member.by_username 'georgiou'
    @member.wont_equal nil
    @member.first_name.must_equal 'George'
    @member.last_name.must_equal 'Testington'
    @member.email.must_equal 'george@example.com'
    @member.receives_mailshots.must_equal false
    @member.current_subscription.must_equal nil
    @member.source.must_equal 'SOMEWHERE'
    @member.log_entries.first.kind_of?(Marina::Db::LogEntry::Registration).must_equal true

    plan.reload
    @application = plan.applications.first
    @application.wont_equal nil
    @application.member.must_equal @member
    @application.supporting_information.must_equal 'I am great'
    @application.status.must_equal 'awaiting_review'
  end

  def then_i_should_receive_an_email_with_payment_details
    # this is handled by the expects call in the previous step
  end

  def then_i_should_receive_an_email_rejection_details
    # this is handled by the expects call in the previous step
  end

  def then_i_should_remain_a_basic_member 
    @member.reload
    @member.current_subscription.must_equal nil
  end
  
  def then_my_registration_should_be_refused
    response.status.must_equal 422
  end

  def then_the_application_should_be_auto_approved
    response.status.must_equal 201

    @member = Marina::Db::Member.by_username 'georgiou'
    @member.wont_equal nil
    @member.first_name.must_equal 'George'
    @member.last_name.must_equal 'Testington'
    @member.email.must_equal 'george@example.com'
    @member.receives_mailshots.must_equal false
    @member.current_subscription.must_equal nil
    @member.source.must_equal 'SOMEWHERE'
    @member.log_entries.first.kind_of?(Marina::Db::LogEntry::Registration).must_equal true

    plan.reload
    @application = plan.applications.first
    @application.wont_equal nil
    @application.member.must_equal @member
    @application.status.must_equal 'approved'
  end

  let(:plan) { a_saved Marina::Db::Subscription::ReviewedPlan, name: 'Gold', feature_levels: ['GOLD'] }
  let(:mailing_list_processor) { stub 'Mailing list processor' }
  let(:payment_processor) { stub 'Payment processor' }
  let(:params) { { first_name: 'George', last_name: 'Testington', email: 'george@example.com', username: 'georgiou', password: 'secret101', password_confirmation: 'secret101', agrees_to_terms: true, receives_mailshots: false, subscription_plan_id: plan.id, source: 'SOMEWHERE', supporting_information: 'I am great' } }
  let(:administrator) { a_saved Marina::Db::Member }
  let(:subscriber_details) { stub active: true, active_until: (Date.today + 10), feature_level: 'GOLD', lifetime_subscription: false, credit: 0.0, identifier: 'George-Testington' }
end
