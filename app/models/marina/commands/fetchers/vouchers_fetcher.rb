require_relative '../fetcher'

module Marina
  module Commands
    module Fetchers
      class VouchersFetcher < Fetcher

        def initialize params = {}
          super params.merge!(permission: :list_vouchers)
        end

        def do_fetch params = nil
          data_store.all
        end

      end
    end
  end
end
