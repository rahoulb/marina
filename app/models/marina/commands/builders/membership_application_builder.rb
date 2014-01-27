require_relative '../builder'

module Marina
  module Commands
    module Builders
      class MembershipApplicationBuilder < Builder
        def initialize params = {}
          super params.merge(permission: nil)
        end
      end
    end
  end
end
