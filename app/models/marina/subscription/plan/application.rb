require 'active_support/core_ext/object/blank'

module Marina
  module Subscription
    module Plan
      module Application

        # params: mail_processor, payment_processor, reason_for_affiliation_rejection
        def accepted_by administrator, params = {}
          update_attributes! administrator: administrator, status: 'approved', reason_for_affiliation_rejection: params[:reason_for_affiliation_rejection]

          mails = params[:mail_processor]
          payments = params[:payment_processor]
          return if mails.nil? && payments.nil?

          payments.apply_credit_to member, affiliate_organisation.discount if !affiliate_organisation.nil? && params[:reason_for_affiliation_rejection].blank?
          mails.application_approved self, payments
        end

        # params: reason, mail_processor
        def rejected_by administrator, params = {}
          update_attributes! administrator: administrator, reason_for_rejection: params[:reason], status: 'rejected'

          mails = params[:mail_processor]
          mails.application_rejected self unless mails.nil?
        end
      end
    end
  end
end
