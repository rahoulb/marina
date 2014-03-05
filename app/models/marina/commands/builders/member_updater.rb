require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/object/try'
require_relative '../builder'

module Marina
  module Commands
    module Builders
      class MemberUpdater < Builder
        def initialize params = {}
          super params.merge(permission: :manage_members)
        end
      end
    end
  end
end
