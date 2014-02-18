require_relative '../fetcher'

module Marina
  module Commands
    module Fetchers
      class Vouchers < Fetcher

        def initialize params = {}
          super params.merge(permission: :list_vouchers)
        end

        def do_fetch params = nil

        end

      end
    end
  end
end
