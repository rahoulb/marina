require_relative '../builder'

module Marina
  module Commands
    module Builders
      class MembershipApplicationUpdater < Builder
        def initialize params = {}
          super params.merge(permission: :approve_membership_applications)
        end

      end
    end
  end
end
