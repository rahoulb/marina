class Api::VouchersController < ApplicationController
  respond_to :json

  def index
    vouchers.do_fetch do | found |
      render action: 'index', locals: { vouchers: found }
    end
  end

  def create
    voucher_builder.build_from voucher_params do | created |
      render partial: 'voucher', locals: { voucher: created }
    end
  end

  def update

  end

  protected

  def vouchers
    @vouchers ||= Marina::Commands::Fetchers::VouchersFetcher.new user: current_user, data_store: Marina::Db::Voucher
  end

  def voucher_builder
    @voucher_builder ||= Marina::Commands::Builders::VoucherBuilder.new user: current_user, data_store: Marina::Db::Voucher
  end

  def voucher_params
    params.require(:voucher).permit(:type, :amount, :days, :site_id, :code)
  end

end
