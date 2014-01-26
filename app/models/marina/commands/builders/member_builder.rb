require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/object/try'
require_relative '../builder'

module Marina
  module Commands
    module Builders
      class MemberBuilder < Builder

        def do_create params = {}
          plan = subscription_plans_store.find params.delete(:subscription_plan_id) unless params[:subscription_plan_id].nil?
          voucher = voucher_store.called params.delete(:voucher_code) unless params[:voucher_code].nil?

          # create the member
          member = data_store.create! params
          # record the registration
          registration_store.create! owner: member unless registration_store.nil?

          # are we passing in any affiliated organisation details?
          affiliate_organisation = affiliate_organisation_store.called(params[:affiliate_organisation])
          params[:affiliate_organisation] = affiliate_organisation unless affiliate_organisation.nil?

          # and notify the rest of the world
          payment_processor.new_subscriber params.slice(:email, :first_name, :last_name).merge(plan: plan) unless payment_processor.nil?
          mailing_list_processor.new_subscriber params.slice(:email, :first_name, :last_name).merge(plan_name: plan.try(:name)) unless mailing_list_processor.nil?

          # ensure the subscription plan is updated
          application = plan.new_application_from member, params.slice(:supporting_information, :auto_approval_code, :affiliate_organisation, :affiliate_membership_details) unless plan.nil?

          # apply any vouchers
          voucher.apply_to (application || member), payment_processor unless voucher.nil?

          return member, plan
        end

      end
    end
  end
end
