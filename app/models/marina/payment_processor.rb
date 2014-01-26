module Marina
  class PaymentProcessor
    # register a new subscriber
    # params - :email, :first_name, :last_name, :plan
    def new_subscriber params = {}

    end

    # return the URL for a given plan and member
    # params - :plan
    def url_for member, params = {}
    end

    def apply_credit_to member, amount

    end

    def add_time_to member, days

    end
  end
end
