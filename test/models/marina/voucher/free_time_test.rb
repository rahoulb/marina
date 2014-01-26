require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../app/models/marina/voucher/free_time'

describe Marina::Voucher::FreeTime do
  subject { voucher_class.new 10 }

  describe "being applied to a new member" do
    describe "when an application is required" do
      it "auto-approves the application" do
        application.expects(:update_attributes).with(status: 'approved')

        subject.apply_to application
      end
    end

    it "adds free time to the payment processor" do
      payment_processor.expects(:add_time_to).with(member, 10)

      subject.apply_to member, payment_processor
    end
  end

  let(:member) { stub 'Member' }
  let(:application) { stub 'Application', member: member }
  let(:payment_processor) { stub 'Payment processor' }
  let(:voucher_class) do
    Class.new(Struct.new(:days)) do
      include Marina::Voucher::FreeTime
    end
  end
end
