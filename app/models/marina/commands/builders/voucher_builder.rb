require_relative '../builder'

module Marina
  module Commands
    module Builders
      class VoucherBuilder < Builder

        def initialize params = {}
          super params.merge(permission: :manage_vouchers)
        end

        def do_create params = {}
          super params
        end

      end
    end
  end
end
