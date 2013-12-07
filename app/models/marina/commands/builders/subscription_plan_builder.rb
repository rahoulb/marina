require_relative '../builder'

module Marina
  module Commands
    module Builders
      class SubscriptionPlanBuilder < Builder
        def initialize params = {}
          super params.merge(permission: :add_subscription_plans)
        end
      end
    end
  end
end
