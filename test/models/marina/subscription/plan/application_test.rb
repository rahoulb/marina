require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/subscription/plan/application'

describe Marina::Subscription::Plan::Application do
  subject { application_class.new }
  before { subject.stubs(:update_attributes!) }

  describe "being accepted" do

    it "records the administrator and updates the status" do
      subject.expects(:update_attributes!).with(administrator: administrator, status: 'approved')
      subject.accepted_by administrator
    end

    it "sends a confirmation email with payment information" do
      mail_processor.expects(:application_approved).with(subject, payment_processor)
      subject.accepted_by administrator, mail_processor: mail_processor, payment_processor: payment_processor
    end
  end

  describe "being rejected" do

    it "records the administrator, reason for rejection and updates the status" do
      subject.expects(:update_attributes!).with(administrator: administrator, status: 'rejected', reason_for_rejection: 'Poop')
      subject.rejected_by administrator, reason: 'Poop'
    end

    it "sends a rejection email" do
      mail_processor.expects(:application_rejected).with(subject)

      subject.rejected_by administrator, reason: 'Poop', mail_processor: mail_processor
    end

  end


  let(:administrator) { stub 'Admin' }
  let(:mail_processor) { stub 'Mail processor' }
  let(:payment_processor) { stub 'Payment processor' }
  let(:application_class) do
    Class.new(Struct.new(:administrator, :status)) do
      include Marina::Subscription::Plan::Application

    end
  end
end
