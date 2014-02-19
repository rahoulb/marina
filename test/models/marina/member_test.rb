require 'minitest/autorun'
require 'mocha/setup'
require 'digest/sha2'
require 'timecop'
require_relative '../../../app/models/marina/member'

describe Marina::Member do
  subject { member_class.new }

  describe "subscriptions" do
    describe "at renewal time" do
      it "reports if this is the first renewal" do
        subject.stubs(:subscriptions).returns([first_subscription])
        subject.first_renewal.must_equal true
      end

      it "reports if this is not the first renewal" do
        subject.stubs(:subscriptions).returns([first_subscription, second_subscription])
        subject.first_renewal.wont_equal true
      end

      let(:first_subscription) { stub 'Subscription' }
      let(:second_subscription) { stub 'Subscription' }
    end

    describe "when the member has an active subscription" do
      before { subject.stubs(:current_subscription).returns(subscription) }

      it "reports the active subscription" do
        subject.subscription_active.must_equal true
      end

      it "reports the subscription plan name" do
        subject.subscription_plan.must_equal subscription.name
      end

      describe "that has a directory listing" do
        before { subscription.stubs(:has_directory_listing).returns(true) }

        it "adds a directory listing" do
          subject.expects(:update_attribute).with(:has_directory_listing, true)

          subject.update_directory_listing
        end
      end

      describe "that does not have a directory listing" do
        before { subscription.stubs(:has_directory_listing).returns(false) }

        it "adds a directory listing" do
          subject.expects(:update_attribute).with(:has_directory_listing, false)

          subject.update_directory_listing
        end
      end
    end

    describe "when the member has an inactive subscription" do
      before { subject.stubs(:current_subscription).returns(nil) }

      it "reports that there are no active subscriptions" do
        subject.subscription_active.must_equal false
      end

      it "does not report the plan name" do
        subject.subscription_plan.must_equal ''
      end

      it "can build a replacement subscription" do
        subject.subscriptions = subscriptions
        subscriptions.expects(:build).returns(:new_subscription)

        subject.build_subscription
      end

      it "does not have a directory listing" do
        subject.expects(:update_attribute).with(:has_directory_listing, false)

        subject.update_directory_listing
      end
    end

    describe "attaching to a plan" do
      before do
        subject.subscriptions = subscriptions
        subscriptions.expects(:create!).with(plan: plan, active: true, expires_on: expiry_date).returns(new_subscription)
      end

      describe "when not on an active plan" do
        before { subject.stubs(:current_subscription).returns(nil) }

        it "creates an active subscription to the plan" do
          subject.subscribe_to plan, expires_on: expiry_date
        end
      end

      describe "when already on an active plan" do
        before { subject.stubs(:current_subscription).returns(subscription) }

        it "cancels the existing plan" do
          subscription.expects(:update_attributes!).with(active: false, expires_on: Date.today)

          subject.subscribe_to plan, expires_on: expiry_date
        end
      end

      let(:plan) { mock 'Plan' }
      let(:expiry_date) { Date.today + 365 }
    end

    let(:subscriptions) { mock 'Array of Subscriptions' }
    let(:new_subscription) { stub name: 'Another Membership Plan' }
  end

  describe "passwords" do
    describe "when an encryption strategy is configured" do
      before do 
        member_class.encryption_strategy = encrypter
        encrypter.expects(:encrypt).with('secret').returns('encryptedsecret')
      end

      it "stores the encrypted password using the given strategy" do
        subject.password = 'secret'
        subject.password_confirmation = 'secret'

        subject.encrypt_password

        subject.encrypted_password.must_equal 'encryptedsecret'
      end

      it "verifies a supplied password" do
        subject.encrypted_password = 'encryptedsecret'

        subject.verify_password('secret').must_equal true
      end
    end

    it "does nothing if the password is blank" do
      subject.encrypted_password = 'nowt'
      subject.password = ''

      subject.encrypt_password

      subject.encrypted_password.must_equal 'nowt'
    end
  end

  describe "name" do
    it "is composed from the first name and last name" do
      subject.first_name = 'George'
      subject.last_name = 'Testington'
      subject.name.must_equal 'George Testington'
    end
  end

  describe "custom fields" do
    before do
      subject.stubs(:field_definition_names).returns(field_definition_names)
      subject.data = { 'this' => 'THIS', 'that' => 'THAT' }
    end

    it "can be read" do
      subject.this.must_equal 'THIS'
      subject.that.must_equal 'THAT'
    end

    it "can be written" do
      subject.this = 'Hello'
      subject.that = 'World'
      subject.data['this'].must_equal 'Hello'
      subject.data['that'].must_equal 'World'
    end

    it "can be accessed via a field definition" do
      subject.value_for(field_definition).must_equal 'THIS'
    end

    it "can be accessed via a field definition even if the data has not been set" do
      subject.data = nil
      subject.value_for(field_definition).must_equal nil
    end

    let(:field_definition_names) { [:this, :that] }
    let(:field_definition) { stub 'Field Definition', name: 'this' }
  end

  describe "API token" do
    it "is generated" do
      subject.generate_api_token
      subject.api_token.wont_equal nil
      (subject.api_token.length > 32).must_equal true
    end
  end

  describe "Payment Processor ID" do
    before { subject.id = 123 }

    it "is generated if it is blank" do
      subject.generate_payment_processor_id
      subject.payment_processor_id.must_equal 100123
    end

    it "does nothing if it is already set" do
      subject.payment_processor_id = 555

      subject.generate_payment_processor_id
      subject.payment_processor_id.must_equal 555
    end

    it "does nothing if the member's ID has not been set" do
      subject.id = nil

      subject.generate_payment_processor_id
      subject.payment_processor_id.must_equal nil
    end
  end

  describe "permissions" do
    before do
      subject.permissions = ['do_something']
    end

    it "can do an action if the permission is recorded" do
      subject.can(:do_something).must_equal true
    end

    it "cannot do an action if the permission is not recorded" do
      subject.can(:do_something_else).wont_equal true
    end
  end

  it "records when a login has happened" do
    Timecop.freeze do
      subject.expects(:update_attribute).with(:last_login_at, Time.now)
      subject.record_login
    end
  end

  let(:member_class) do 
    Class.new(Struct.new(:id, :first_name, :last_name, :password, :password_confirmation, :encrypted_password, :subscriptions, :api_token, :permissions, :data, :has_directory_listing, :payment_processor_id)) do
      include Marina::Member

      class << self
        attr_accessor :encryption_strategy
      end
    end
  end

  let(:encrypter) { stub }
  let(:subscription) { stub name: 'Premium Membership Plan' }
end
