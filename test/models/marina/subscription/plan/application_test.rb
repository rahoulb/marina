require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/subscription/plan/application'

describe Marina::Subscription::Plan::Application do
  subject { application_class.new member }
  before { subject.stubs(:update_attributes!) }

  describe "being accepted" do
    it "records the administrator and updates the status" do
      subject.expects(:update_attributes!).with(administrator: administrator, status: 'approved', reason_for_affiliation_rejection: nil)
      subject.accepted_by administrator
    end

    it "sends a confirmation email with payment information" do
      mail_processor.expects(:application_approved).with(subject, payment_processor)
      subject.accepted_by administrator, mail_processor: mail_processor, payment_processor: payment_processor
    end

    describe "when the application includes affiliate details" do
      before do 
        subject.affiliate_organisation = affiliate_organisation
        subject.affiliate_membership_details = 'Hello'

        mail_processor.stubs(:application_approved)
      end

      describe "and the affiliate details are accepted" do

        it "applies a credit to the members account" do
          payment_processor.expects(:apply_credit_to).with(member, 25.0)

          subject.accepted_by administrator, mail_processor: mail_processor, payment_processor: payment_processor
        end
      end

      describe "and the affiliate details are rejected" do
        it "does not apply a credit to the members account" do
          subject.accepted_by administrator, mail_processor: mail_processor, payment_processor: payment_processor, reason_for_affiliation_rejection: 'Wrong'
        end

        it "stores the reason for rejection" do
          subject.expects(:update_attributes!).with(administrator: administrator, status: 'approved', reason_for_affiliation_rejection: 'Wrong')
          subject.accepted_by administrator, mail_processor: mail_processor, payment_processor: payment_processor, reason_for_affiliation_rejection: 'Wrong'
        end
      end
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
  let(:affiliate_organisation) { stub 'Affiliate Organisation', discount: 25.0 }
  let(:member) { stub 'Member' }
  let(:application_class) do
    Class.new(Struct.new(:member, :administrator, :status, :affiliate_organisation, :affiliate_membership_details)) do
      include Marina::Subscription::Plan::Application
    end
  end
end
