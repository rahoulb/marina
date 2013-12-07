require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../app/models/marina/commands/job'

describe Marina::Commands::Job do
  subject { Marina::Commands::Job.new user: user }

  it "stores the user id when being created" do
    subject.user_id.must_equal 123
  end

  it "calls the execute method when performed" do
    subject.expects(:execute).returns(true)

    result = subject.perform
    result.must_equal true
  end

  let(:user) { mock 'User', id: 123 }
end
