require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/jobs/renewal_notifier'

describe Marina::Commands::Jobs::RenewalNotifier do
  subject { Marina::Commands::Jobs::RenewalNotifier.new user: user }

  before do 
    subject.stubs(:user).returns(user) 
    user.stubs(:can).with(:send_renewal_notifications).returns(true)
    subject.stubs(:two_week_renewals).returns(members)
    subject.stubs(:four_week_renewals).returns(members)
    subject.stubs(:mail_processor).returns(mail_processor)

    first_member.stubs(:first_renewal).returns(true)
    second_member.stubs(:first_renewal).returns(false)

    mail_processor.stubs(:two_week_renewal_notification)
    mail_processor.stubs(:initial_two_week_renewal_notification)
    mail_processor.stubs(:four_week_renewal_notification)
    mail_processor.stubs(:initial_four_week_renewal_notification)
  end

  it "expects the send_renewal_notifications permission" do
    subject.permission.must_equal :send_renewal_notifications
  end

  it "sends a notification to every member on their first renewal" do
    mail_processor.expects(:initial_two_week_renewal_notification).with(first_member)
    mail_processor.expects(:initial_four_week_renewal_notification).with(first_member)

    subject.perform
  end

  it "sends a notification to every member on their subsequent renewals" do
    mail_processor.expects(:two_week_renewal_notification).with(second_member)
    mail_processor.expects(:four_week_renewal_notification).with(second_member)

    subject.perform
  end

  let(:user) { stub 'User', id: 123 }
  let(:members) { [first_member, second_member] }
  let(:first_member) { stub 'Member', email: 'first@example.com' }
  let(:second_member) { stub 'Member', email: 'second@example.com' }
  let(:mail_processor) { stub 'MailProcessor' }
end
