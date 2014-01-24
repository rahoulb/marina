require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/subscription/plan/application'

describe Marina::Subscription::Plan::Application do
  subject { application_class.new }

  before { subject.stubs(:save!) }

  describe "being accepted" do
    it "records the administrator" do
      subject.accepted_by administrator
      subject.administrator.must_equal administrator
    end

    it "sends a confirmation email with payment information" do
      mail_processor.expects(:application_approved).with(subject, payment_processor)

      subject.accepted_by administrator, mail_processor: mail_processor, payment_processor: payment_processor
    end
  end


  let(:administrator) { stub 'Admin' }
  let(:mail_processor) { stub 'Mail processor' }
  let(:payment_processor) { stub 'Payment processor' }
  let(:application_class) do
    Class.new(Struct.new(:administrator, :state)) do
      include Marina::Subscription::Plan::Application

    end
  end
end
