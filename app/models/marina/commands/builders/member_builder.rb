require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/object/try'
require_relative '../builder'

module Marina
  module Commands
    module Builders
      class MemberBuilder < Builder

        def do_create params = {}
          plan = subscription_plans_store.find params.delete(:subscription_plan_id) unless params[:subscription_plan_id].nil?

          # create the member
          member = data_store.create! params
          # record the registration
          registration_store.create! owner: member unless registration_store.nil?


          # and notify the rest of the world
          payment_processor.new_subscriber params.slice(:email, :first_name, :last_name).merge(plan: plan) unless payment_processor.nil?
          mailing_list_processor.new_subscriber params.slice(:email, :first_name, :last_name).merge(plan_name: plan.try(:name)) unless mailing_list_processor.nil?

          return member, plan
        end

      end
    end
  end
end
