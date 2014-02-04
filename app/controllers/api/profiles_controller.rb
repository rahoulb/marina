class Api::ProfilesController < ApplicationController
  respond_to :json

  def update
    member.update current_user, member_params do | updated |
      render partial: '/api/members/member', locals: { member: updated, field_definitions: field_definitions }
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
    keys = STANDARD_FIELDS + Marina::Db::FieldDefinition.names
    params.require(:member).permit(keys)
  end

  def field_definitions
    Marina::Db::FieldDefinition.all
  end

  STANDARD_FIELDS = [:first_name, :last_name, :email, :username, :password, :password_confirmation, :title, :address, :town, :county, :postcode, :country, :telephone, :web_address, :biography]

end
