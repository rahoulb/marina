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

    # An application onto an approval-required plan has been rejected
    def application_rejected application

    end

    def initial_two_week_renewal_notification member

    end

    def two_week_renewal_notification member

    end

    def initial_four_week_renewal_notification member

    end

    def four_week_renewal_notification member

    end

  end
end
