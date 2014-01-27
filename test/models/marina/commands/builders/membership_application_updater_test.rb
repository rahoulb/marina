require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/builders/membership_application_updater'

describe Marina::Commands::Builders::MembershipApplicationUpdater do
  subject { Marina::Commands::Builders::MembershipApplicationUpdater.new user: user, data_store: data_store, mail_processor: mail_processor, payment_processor: payment_processor }

  before do 
    user.stubs(:can).with(:approve_membership_applications).returns(true)
    data_store.stubs(:find).with(123).returns(application)
  end

  it "requires the :approve_membership_applications permission" do
    subject.permission.must_equal :approve_membership_applications
  end

  it "accepts an application" do
    application.expects(:accepted_by).with(user, mail_processor: mail_processor, payment_processor: payment_processor)
    result = nil
    subject.accept 123 do | accepted |
      result = accepted
    end
    result.must_equal application
  end

  it "rejects an application" do
    application.expects(:rejected_by).with(user, reason_for_rejection: 'Stupid', mail_processor: mail_processor)
    result = nil
    subject.reject 123, reason_for_rejection: 'Stupid' do | rejected |
      result = rejected
    end 
    result.must_equal application
  end

  let(:user) { stub 'User' }
  let(:data_store) { stub 'Data store' }
  let(:application) { stub 'Application' }
  let(:mail_processor) { stub 'Mail Processor' }
  let(:payment_processor) { stub 'Payment Processor' }
end
