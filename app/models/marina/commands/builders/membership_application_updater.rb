require_relative '../builder'

module Marina
  module Commands
    module Builders
      class MembershipApplicationUpdater < Builder
        def initialize params = {}
          super params.merge(permission: :approve_membership_applications)
        end

        # mark the given application as accepted
        # params: reason_for_affiliation_rejection, mail_processor, payment_processor
        def accept id_or_application, params = {}
          check_security!
          find id_or_application do | appl |
            appl.accepted_by user, params.merge(mail_processor: mail_processor, payment_processor: payment_processor)
            yield appl 
          end
        end

        # mark the given application as rejected
        # params: reason_for_rejection, mail_processor
        def reject id_or_application, params = {}
          check_security!
          find id_or_application do | appl |
            appl.rejected_by user, params.merge(mail_processor: mail_processor)
            yield appl
          end
        end

      end
    end
  end
end
