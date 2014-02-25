class Api::VouchersController < ApplicationController
  respond_to :json

  def index
    vouchers.fetch do | found |
      render action: 'index', locals: { vouchers: found }
    end
  end

  def create
    voucher_builder.build_from voucher_params do | created |
      render partial: '/api/vouchers/voucher', locals: { voucher: created }
    end
  end

   def update
    voucher_builder.update params[:id], voucher_params do | updated |
      render partial: '/api/vouchers/voucher', locals: { voucher: updated }
    end
  end

  def destroy
    begin
      voucher_builder.find params[:id] do |voucher|
        voucher.destroy
      end

      render json: { status: 200 }

    rescue Exception => e
      render json: {}, status: 404
    end
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
