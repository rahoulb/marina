require_relative '../builder'

module Marina
  module Commands
    module Builders
      class MailoutsBuilder < Builder
        def initialize params = {}
          super params.merge(permission: :send_mailouts)
        end
      end
    end
  end
end
