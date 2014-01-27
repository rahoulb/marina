require 'minitest/autorun'
require_relative '../../../../../app/models/marina/commands/builders/membership_application_updater'

describe Marina::Commands::Builders::MembershipApplicationUpdater do
  subject { Marina::Commands::Builders::MembershipApplicationUpdater.new }

  it "requires the :approve_membership_applications permission" do
    subject.permission.must_equal :approve_membership_applications
  end
end
