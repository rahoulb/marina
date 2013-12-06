require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/builders/mailouts_builder'

describe Marina::Commands::Builders::MailoutsBuilder do
  subject { Marina::Commands::Builders::MailoutsBuilder.new }

  it "requires the send_mailouts permission" do
    subject.permission.must_equal :send_mailouts
  end

end
