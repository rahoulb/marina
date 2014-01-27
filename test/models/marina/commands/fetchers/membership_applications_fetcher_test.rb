require 'minitest/autorun'
require_relative '../../../../../app/models/marina/commands/fetchers/membership_applications_fetcher'

describe Marina::Commands::Fetchers::MembershipApplicationsFetcher do
  subject { Marina::Commands::Fetchers::MembershipApplicationsFetcher.new }

  it "requires the :approve_membership_applications permission" do
    subject.permission.must_equal :approve_membership_applications
  end
end
