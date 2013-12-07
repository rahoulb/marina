require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/jobs/individual_mailout_delivery'

describe Marina::Commands::Jobs::IndividualMailoutDelivery do
  subject { Marina::Commands::Jobs::IndividualMailoutDelivery.new user: user, mailout_id: 123, member_id: 456 }

  before do
    subject.stubs(:mailout).returns(mailout)
    subject.stubs(:member).returns(member)
  end

  it "generates an email for the given member and delivers it" do
    subject.stubs(:email_for).with(member).returns(email)
    email.expects(:deliver)
    mailout.expects(:record_delivery_to).with(member)

    subject.perform
  end

  let(:user) { mock 'User', id: 999 }
  let(:mailout) { mock 'Mailout' }
  let(:member) { mock 'Member' }
  let(:email) { mock 'Email' }
end
