require_relative '../fetcher'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/keys'

module Marina
  module Commands
    module Fetchers
      class MembersFetcher < Fetcher

        def initialize params = {}
          super params.merge(permission: :manage_members)
        end

        def do_fetch params = {}
          data_store.all
        end

      end
    end
  end
end