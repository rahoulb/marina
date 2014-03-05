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
          search = "%#{params[:query]}%"
          data_store.where("username like ? or email like ?", search, search)
        end
      end
    end
  end
end