class Api::ProfilesController < ApplicationController
  respond_to :json

  def update
    member.update current_user, member_params do | updated |
      render partial: '/api/members/member', locals: { member: updated }
    end
  end

  protected

  def member
    Marina::Commands::Builders::ProfileUpdater.new({
      user: current_user,
      data_store: Marina::Db::Member
    })
  end

  def member_params
    params.require(:member).permit(:first_name, :last_name, :email, :username, :password, :password_confirmation, :title, :address, :town, :county, :postcode, :country, :telephone, :web_address)
  end

end
