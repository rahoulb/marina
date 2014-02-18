require 'minitest/autorun'
require_relative '../../../../../app/models/marina/commands/fetchers/vouchers_fetcher'

describe Marina::Commands::Fetchers::VouchersFetcher do
  subject { Marina::Commands::Fetchers::VouchersFetcher.new }

  it "requires the :list_vouchers permission" do
    subject.permission.must_equal :list_vouchers
  end
end
