require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/fetchers/members_fetcher'

describe Marina::Commands::Fetchers::MembersFetcher do

  subject { Marina::Commands::Fetchers::MembersFetcher.new }

  it "requires the :manage_members permission" do
    subject.permission.must_equal :manage_members
  end

end