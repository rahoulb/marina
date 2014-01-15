require_relative '../fetcher'

module Marina
  module Commands
    module Fetchers
      class LatestMembersFetcher < Fetcher

        def do_fetch params = {}
          count = params[:count] || 6
          fetcher = basic_fetcher
          fetcher.latest_members(count)
        end

        protected

        def basic_fetcher
          return data_store.by_visibility(visibility) if user.nil? || !user.can(:access_all_members)
          return data_store
        end

        def visibility
          return "all" if user.nil?
        end
      end
    end
  end
end
