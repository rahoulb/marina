require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/builders/voucher_builder'

describe Marina::Commands::Builders::VoucherBuilder do
  subject { Marina::Commands::Builders::VoucherBuilder.new }

  it "requires the :manage_voucherspermission" do
    subject.permission.must_equal :manage_vouchers
  end
end
