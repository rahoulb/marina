require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../app/models/marina/voucher/credit'

describe Marina::Voucher::Credit do
  subject { voucher_class.new 22.50 }

  describe "being applied to a new member" do

    it "adds free time to the payment processor" do
      payment_processor.expects(:apply_credit_to).with(member, 22.50)

      subject.apply_to member, payment_processor
    end
  end

  let(:member) { stub 'Member' }
  let(:payment_processor) { stub 'Payment processor' }
  let(:voucher_class) do
    Class.new(Struct.new(:amount)) do
      include Marina::Voucher::Credit
    end
  end
end
