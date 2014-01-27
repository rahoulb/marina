require_relative '../fetcher'

module Marina
  module Commands
    module Fetchers
      class MembershipApplicationsFetcher < Fetcher
        def initialize params = {}
          super params.merge(permission: :approve_membership_applications)
        end

        def do_fetch params = {}
          data_store.outstanding
        end
      end
    end
  end
end
