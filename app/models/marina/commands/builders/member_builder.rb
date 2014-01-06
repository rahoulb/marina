require 'active_support/core_ext/hash/slice'
require_relative '../builder'

module Marina
  module Commands
    module Builders
      class MemberBuilder < Builder

        def do_create params = {}
          plan = subscription_plans_store.find params.delete(:subscription_plan_id)

          member = data_store.create! params

          # attach the member to the subscription plan
          member.subscribe_to plan

          # and notify the external services
          payment_processor.new_subscriber params.slice(:email, :first_name, :last_name).merge(plan_name: plan.name) unless payment_processor.nil?
          mailing_list_processor.new_subscriber params.slice(:email, :first_name, :last_name).merge(plan_name: plan.name) unless mailing_list_processor.nil?

          return member
        end

      end
    end
  end
end
