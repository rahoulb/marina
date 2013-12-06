require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../app/models/marina/mailout'

describe Marina::Mailout do
  subject { mailout_class.new sender, '' }

  describe "setting the from address" do
    describe "when the from address is blank" do
      before { subject.from_address = '' }

      it "sets the from address to the email address of the sender" do
        subject.set_from_address
        subject.from_address.must_equal sender.email
      end
    end

    describe "when the from address has been set" do
      before { subject.from_address = 'me@myplace.com' }

      it "does not change the from address" do
        subject.set_from_address
        subject.from_address.must_equal 'me@myplace.com'
      end
    end
  end

  let(:sender) { stub email: 'george@example.com' }
  let(:mailout_class) do 
    Class.new(Struct.new(:sender, :from_address)) do
      include Marina::Mailout
    end
  end
end
