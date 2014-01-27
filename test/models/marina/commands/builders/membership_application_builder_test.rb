require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/builders/membership_application_builder'

describe Marina::Commands::Builders::MembershipApplicationBuilder do
  subject { Marina::Commands::Builders::MembershipApplicationBuilder.new }

  it "requires no special permissions" do
    subject.permission.must_equal nil
  end
end
