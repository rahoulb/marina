module Marina
  class MailingListProcessor
    # A new subscriber has been added
    # params - :email, :first_name, :last_name, :plan_name
    def new_subscriber params = {}

    end

    # An application onto an approval-required plan has been approved
    def application_approved application, payment_processor
      # application is expected to be a Marina::Db::ReviewedPlan::Application
    end

  end
end
