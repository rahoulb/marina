module Marina
  module Subscription
    module Plan
      module Application

        # params: mail_processor, payment_processor
        def accepted_by administrator, params = {}
          self.administrator = administrator
          self.save!
          mails = params[:mail_processor]
          payments = params[:payment_processor]
          return if mails.nil? && payments.nil?

          mails.application_approved self, payments
        end
      end
    end
  end
end
