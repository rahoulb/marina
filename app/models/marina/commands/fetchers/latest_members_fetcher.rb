require_relative '../fetcher'

module Marina
  module Commands
    module Fetchers
      class LatestMembersFetcher < Fetcher

        def do_fetch params = {}
          count = params[:count] || 6
          data_store.latest_members(visible_to: visibility, count: count)
        end

        protected

        def visibility
          return "all" if user.nil?
        end
      end
    end
  end
end
