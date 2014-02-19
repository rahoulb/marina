require_relative "../test_helper"

describe 'VoucherAPI Integration Test' do

  it 'fetch all vouchers' do
    login_as member
    create_vouchers
    fetch_vouchers
  end

  it 'creates a new voucher of type Voucher::Credit' do
    login_as member
    create_voucher_of_type('Marina::Db::Voucher::Credit')
  end


  it 'creates a new voucher of type Voucher::FreeTime' do
    login_as member
    create_voucher_of_type('Marina::Db::Voucher::FreeTime')
  end

  let(:member) { a_saved Marina::Db::Member }
  let(:params) { { code: 'SAMPLE', days: 10, amount: 12.0 } }
end


def create_vouchers
  @voucher = a_saved Marina::Db::Voucher::FreeTime, code: 'FREESTUFF', days: 10
  @voucher = a_saved Marina::Db::Voucher::Credit, code: 'FREESTUFF', amount: 10.0
end

def fetch_vouchers
  get "/api/vouchers", format: 'json'
  response.status.must_equal 200
end

def create_voucher_of_type(type)
  post "/api/vouchers", voucher: params.merge(type: type)
  response.status.must_equal 200
end