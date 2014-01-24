module Marina
  module Subscription
    module Plan
      module Application

        # params: mail_processor, payment_processor
        def accepted_by administrator, params = {}
          update_attributes! administrator: administrator, status: 'approved'

          mails = params[:mail_processor]
          payments = params[:payment_processor]
          return if mails.nil? && payments.nil?

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
