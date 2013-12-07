require_relative '../builder'

module Marina
  module Commands
    module Builders
      class MailoutsBuilder < Builder
        def initialize params = {}
          super params.merge(permission: :send_mailouts)
        end

        def do_create params = {}
          super params.merge(sender_id: user.id)
        end
      end
    end
  end
end
