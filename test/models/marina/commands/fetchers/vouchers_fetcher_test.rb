require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/voucher/credit'
require_relative '../../../../../app/models/marina/commands/fetchers/vouchers_fetcher'

describe Marina::Commands::Fetchers::VouchersFetcher do

  subject { Marina::Commands::Fetchers::VouchersFetcher.new }

  it "requires the :manage_vouchers permission" do
    subject.permission.must_equal :manage_vouchers
  end


  # let(:member) { stub 'Member' }
  # let(:payment_processor) { stub 'Payment processor' }
  # let(:credit_voucher_class) do
  #   Class.new(Struct.new(:amount)) do
  #     include Marina::Voucher::Credit
  #   end
  # end

  # let(:free_voucher_class) do
  #   Class.new(Struct.new(:amount)) do
  #     include Marina::Voucher::FreeTime
  #   end
  # end

end
