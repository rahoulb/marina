class Api::MembersController < ApplicationController
  respond_to :json

  def index
    members.fetch do | found |
      render action: 'index', locals: { members: found }
    end
  end

  def create
    member_builder.build_from member_params do | member, plan |
      render partial: 'member', locals: { member: member, field_definitions: field_definitions }, status: 201
    end
  end

  protected

  def member_builder
    Marina::Commands::Builders::MemberBuilder.new({
      user: current_user, 
      data_store: Marina::Db::Member, 
      subscription_plans_store: Marina::Db::Subscription::Plan, 
      payment_processor: Rails.application.config.payment_processor, 
      mailing_list_processor: Rails.application.config.mailing_list_processor, 
      registration_store: Marina::Db::LogEntry::Registration,
      affiliate_organisation_store: Marina::Db::AffiliateOrganisation, 
      voucher_store: Marina::Db::Voucher
    })
  end

  def field_definitions
    Marina::Db::FieldDefinition.all
  end

  def members
    @members ||= Marina::Commands::Fetchers::MembersFetcher.new user: current_user, data_store: Marina::Db::Member
  end

  def member_params
    params.require(:member).permit(:first_name, :last_name, :email, :username, :password, :password_confirmation, :agrees_to_terms, :receives_mailshots, :subscription_plan_id, :source, :supporting_information, :auto_approval_code, :affiliate_organisation, :affiliate_membership_details, :voucher_code)
  end
end
