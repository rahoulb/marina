require_relative "../test_helper"

describe "RenewalNotifications Integration Test" do
  it "sends out four week renewal notifications" do
    given_a_configured_mailing_list_processor
    given_some_members_awaiting_renewal_in_four_weeks
    when_the_four_week_renewal_notifications_are_sent
    then_the_notifications_should_be_sent
  end

  it "sends out two week renewal notifications" do
    given_a_configured_mailing_list_processor
    given_some_members_awaiting_renewal_in_two_weeks
    when_the_two_week_renewal_notifications_are_sent
    then_the_notifications_should_be_sent
  end

  let(:plan) { a_saved Marina::Db::Subscription::PaidPlan }
  let(:first) { a_saved Marina::Db::Member }
  let(:second) { a_saved Marina::Db::Member }
  let(:admin) { a_saved Marina::Db::Member, permissions: ['send_renewal_notifications'] }
  let(:mailing_list_processor) { stub 'Mail processor' }

  def given_a_configured_mailing_list_processor
    Marina::Application.config.mailing_list_processor = mailing_list_processor
  end

  def given_some_members_awaiting_renewal_in_two_weeks
    first.subscriptions.create! plan: plan, active: true, expires_on: (Date.today + 14)
    second.subscriptions.create! plan: plan, active: false, expires_on: (Date.today - 300)
    second.subscriptions.create! plan: plan, active: true, expires_on: (Date.today + 14)
  end

  def given_some_members_awaiting_renewal_in_four_weeks
    first.subscriptions.create! plan: plan, active: true, expires_on: (Date.today + 28)
    second.subscriptions.create! plan: plan, active: false, expires_on: (Date.today - 300)
    second.subscriptions.create! plan: plan, active: true, expires_on: (Date.today + 28)
  end

  def when_the_two_week_renewal_notifications_are_sent
    notifier = Marina::Commands::Jobs::RenewalNotifier.new user: admin 

    mailing_list_processor.expects(:initial_two_week_renewal_notification).with(first)
    mailing_list_processor.expects(:two_week_renewal_notification).with(second)

    notifier.perform
  end

  def when_the_four_week_renewal_notifications_are_sent
    notifier = Marina::Commands::Jobs::RenewalNotifier.new user: admin

    mailing_list_processor.expects(:initial_four_week_renewal_notification).with(first)
    mailing_list_processor.expects(:four_week_renewal_notification).with(second)

    notifier.perform
  end

  def then_the_notifications_should_be_sent
    # handled by the expects on mail processor
  end
end
