require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/jobs/mailout_sender'

describe Marina::Commands::Jobs::MailoutSender do
  subject { Marina::Commands::Jobs::MailoutSender.new user: user, mailout_id: 456 }

  before do
    subject.stubs(:mailout).returns(mailout)
    subject.stubs(:recipient_fetcher).returns(recipient_fetcher)
    subject.stubs(:queue).returns(queue)
  end

  it "schedules an individual mail delivery for all members" do
    recipient_fetcher.expects(:fetch).yields(members)
    members.each do | member |
      subject.expects(:delivery_for).with(member).returns(individual_mailout_delivery)
    end
    queue.expects(:enqueue).with(individual_mailout_delivery).returns(true).at_least(members.count)

    subject.perform
  end

  let(:user) { mock 'User', id: 123 }
  let(:mailout) { mock 'Mailout' }
  let(:recipient_fetcher) { mock 'Recipient Fetcher' }
  let(:queue) { mock 'Queue' }
  let(:members) { [member_one, member_two] }
  let(:member_one) { mock 'Member' }
  let(:member_two) { mock 'Member' }
  let(:individual_mailout_delivery) { mock 'Individual Mailout Delivery Job' }
end
