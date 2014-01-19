require_relative '../fetcher'

module Marina
  module Commands
    module Fetchers
      class LatestMembersFetcher < Fetcher

        def do_fetch params = {}
          count = params[:count] || 6
          return visible_to_all(count) if user.nil?
          return access_all_members(count) if user.can(:access_all_members)
          return private_members(count)
        end

        protected

        def visible_to_all count
          data_store.by_visibility('all').latest_members(count)
        end

        def access_all_members count
          data_store.latest_members(count)
        end

        def private_members count
          results = []
          data_store.all_latest_members.each do | member |
            results << member if user_can_see(member)

            return results if results.size >= count
          end
          return results
        end

        def user_can_see member
          return true if member.visible_to == 'all'
          return (member.visible_to == 'some') && member.visible_plans.include?(user.current_subscription_plan.id)
        end

      end
    end
  end
end
