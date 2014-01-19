require 'active_support/core_ext/object/blank'
require 'rujitsu'

module Marina
  module Member
    # expects the implementer to have 
    # first_name, last_name
    # password, password_confirmation and encrypted_password
    # current_subscription (which returns nil or a subscription that answers to #active and #name)
    # subscriptions (which answers to #build)
    # the implementing class should answer #encryption_strategy with a class that answers to #encrypt(password)
    #
    def can action
      return (permissions || []).include? action.to_s
    end

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

    def current_subscription_plan
      current_subscription.plan
    end

    def build_subscription
      subscriptions.build
    end

    def subscribe_to plan, params = {} 
      current_subscription.update_attributes! active: false, expires_on: Date.today unless current_subscription.nil?
      subscriptions.create! plan: plan, active: true, expires_on: params[:expires_on]
    end

    def generate_api_token
      self.api_token = 48.random_letters
    end

  end
end
