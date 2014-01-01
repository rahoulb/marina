require 'active_support/core_ext/object/blank'

module Marina
  module Member
    # expects the implementer to have 
    # first_name, last_name
    # password, password_confirmation and encrypted_password
    # current_subscription (which returns nil or a subscription that answers to #active and #name)
    # the implementing class should answer #encryption_strategy with a class that answers to #encrypt(password)

    def name
      "#{first_name} #{last_name}"
    end

    def encrypt_password
      return if password.blank?

      self.encrypted_password = self.class.encryption_strategy.encrypt(password)
    end

    def verify_password password
      return encrypted_password == self.class.encryption_strategy.encrypt(password)
    end

    def subscription_active
      return !current_subscription.nil?
    end

    def subscription_plan
      return current_subscription.nil? ? '' : current_subscription.name
    end

  end
end
