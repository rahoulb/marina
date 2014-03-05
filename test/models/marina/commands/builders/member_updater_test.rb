require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/builders/member_updater'

describe Marina::Commands::Builders::MemberUpdater do

  subject { Marina::Commands::Builders::MemberUpdater.new }

  it "requires the :manage_members permission" do
    subject.permission.must_equal :manage_members
  end

end