require_relative '../fetcher'

module Marina
  module Commands
    module Fetchers
      class RecipientFetcher < Fetcher

        def do_fetch params = nil
          return [user] if mailout.test
          plans = mailout.send_to_all_members ? all_plans : mailout.recipient_plan_ids.collect { | id | plan(id) }
          return plans.collect { | p | p.members }.flatten
        end

        def all_plans
          Marina::Db::Subscription::Plan.all
        end

        def plan id
          Marina::Db::Subscription::Plan.find id
        end

      end
    end
  end
end
