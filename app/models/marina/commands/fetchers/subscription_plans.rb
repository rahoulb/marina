require_relative '../fetcher'

module Marina
  module Commands
    module Fetchers
      class SubscriptionPlans < Fetcher
        def initialize params = {}
          super params.merge(permission: :list_subscription_plans)
        end

        def do_fetch params = nil
          data_store.in_order
        end
      end
    end
  end
end
