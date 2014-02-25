require_relative "../test_helper"

describe 'VoucherAPI Integration Test' do
  describe 'when user is not logged in' do
    it 'should not able to manage voucher' do
      fetch_vouchers
      response_should_not_be_success
    end
  end

  describe 'when user is logged in' do
    describe 'and have invalid permissions' do
      it 'should not able to manage voucher' do
        member.update_attribute :permissions, []
        login_as member
        fetch_vouchers
        response_should_not_be_success
      end
    end

    describe 'and has valid valid permissions' do

      it 'fetch all vouchers' do
        login_as member
        create_vouchers
        fetch_vouchers
        response_should_be_success
      end

      it 'creates a new voucher of type Voucher::Credit' do
        login_as member
        create_voucher_of_type('Marina::Db::Voucher::Credit')
        response_should_be_success
      end


      it 'creates a new voucher of type Voucher::FreeTime' do
        login_as member
        create_voucher_of_type('Marina::Db::Voucher::FreeTime')
        response_should_be_success
      end

      it 'should update a voucher' do
        login_as member
        create_vouchers
        update_voucher Marina::Db::Voucher.last.id, { code: 'UPDATED' }
        response_should_be_success
      end

      it 'should delete a valid voucher' do
        login_as member
        create_vouchers
        delete_voucher Marina::Db::Voucher.last.id
        response_should_be_success
      end

      it 'should delete a invalid voucher' do
        login_as member
        create_vouchers
        delete_voucher 40
        response.status.must_equal 404
      end
    end
  end

  let(:member) { a_saved Marina::Db::Member, permissions: ['manage_vouchers'] }
  let(:params) { { code: 'SAMPLE', days: 10, amount: 12.0 } }
end


def create_vouchers
  @voucher = a_saved Marina::Db::Voucher::FreeTime, code: 'FREESTUFF', days: 10
  @voucher = a_saved Marina::Db::Voucher::Credit, code: 'FREESTUFF', amount: 10.0
end

def fetch_vouchers
  get "/api/vouchers", format: 'json'
end

def create_voucher_of_type(type)
  post "/api/vouchers", voucher: params.merge(type: type), format: 'json'
  response_should_be_success
end

def update_voucher(voucher_id, params)
  put "/api/vouchers/#{voucher_id}", voucher: params
end

def delete_voucher(voucher_id)
  delete "/api/vouchers/#{voucher_id}"
end

def response_should_be_success
  response.status.must_equal 200
end

def response_should_not_be_success
  response.status.must_equal 401
end

