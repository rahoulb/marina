require_relative "../test_helper"

describe "MembersSubscriptionChangesViaPinPayments Integration Test" do
  before do
    Rails.application.config.mailing_list_processor = mailing_list_processor
    Rails.application.config.payment_processor = payment_processor
  end

  it "adds a member onto a plan" do
    given_some_plans
    when_the_member_is_added_to_a_plan
    then_the_member_should_be_assigned_to_that_plan
  end

  it "changes the plan that a member is on" do
    given_some_plans
    given_a_member_assigned_to_a_plan
    when_the_members_plan_changes
    then_the_members_plan_details_should_change
  end

  it "makes a members current plan inactive" do
    given_some_plans
    given_a_member_assigned_to_a_plan
    when_the_members_plan_expires
    then_the_member_should_become_a_basic_member
  end

  def given_some_plans
    plan_1.touch
    plan_2.touch
  end

  def given_a_member_assigned_to_a_plan
    member.subscriptions.create! plan: plan_1, active: true, expires_on: 10.days.from_now
  end

  def when_the_member_is_added_to_a_plan
    post "/api/pin_payment_notifications", subscriber_ids: [member.id]
    response.status.must_equal 200

    payment_processor.expects(:get_subscriber_details).with(member.id.to_s).returns(subscriber_details_for_plan_1)
    Delayed::Worker.new.work_off

    member.reload
  end

  def when_the_members_plan_changes
    post "/api/pin_payment_notifications", subscriber_ids: [member.id]
    response.status.must_equal 200

    payment_processor.expects(:get_subscriber_details).with(member.id.to_s).returns(subscriber_details_for_plan_2)
    Delayed::Worker.new.work_off

    member.reload
  end

  def when_the_members_plan_expires
    post "/api/pin_payment_notifications", subscriber_ids: [member.id]
    response.status.must_equal 200

    payment_processor.expects(:get_subscriber_details).with(member.id.to_s).returns(subscriber_details_for_expiry)
    Delayed::Worker.new.work_off

    member.reload
  end

  def then_the_member_should_be_assigned_to_that_plan
    member.current_subscription_plan.must_equal plan_1
    member.current_subscription.active.must_equal true
    member.current_subscription.expires_on.must_equal (Date.today + 365)
    member.has_directory_listing.must_equal true
  end

  def then_the_members_plan_details_should_change
    member.current_subscription_plan.must_equal plan_2
    member.has_directory_listing.must_equal false
    member.current_subscription.active.must_equal true
    member.current_subscription.expires_on.must_equal (Date.today + 90)
  end

  def then_the_member_should_become_a_basic_member
    member.current_subscription.must_equal nil
    member.has_directory_listing.must_equal false
  end


  let(:mailing_list_processor) { mock 'Mailing List Processor' }
  let(:payment_processor) { mock 'Payment Processor' }

  let(:plan_1) { a_saved Marina::Db::Subscription::PaidPlan, feature_levels: ['PREMIUM'], has_directory_listing: true }
  let(:plan_2) { a_saved Marina::Db::Subscription::PaidPlan, feature_levels: ['PLATINUM'], has_directory_listing: false }
  let(:member) { a_saved Marina::Db::Member }

  let(:subscriber_details_for_plan_1) { stub active: true, active_until: (Date.today + 365), feature_level: 'PREMIUM', lifetime_subscription: false, credit: 0.0, identifier: 'George-Testington' }
  let(:subscriber_details_for_plan_2) { stub active: true, active_until: (Date.today + 90), feature_level: 'PLATINUM', lifetime_subscription: false, credit: 0.0, identifier: 'George-Testington' }
  let(:subscriber_details_for_expiry) { stub active: false, active_until: nil, feature_level: nil, lifetime_subscription: false, credit: 0.0, identifier: 'George-Testington' }

end
