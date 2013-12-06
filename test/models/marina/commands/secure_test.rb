require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../app/models/marina/commands/secure'

describe Marina::Commands::Secure do
  subject { Marina::Commands::Secure.new }

  describe "when the permission is not set" do
    describe "and there is no user" do
      it "passes the security check" do
        subject.check_security!
      end
    end

    describe "and there is a user" do
      before { subject.user = user }

      it "passes the security check" do
        subject.check_security!
      end
    end
  end

  describe "when the permission is set" do
    before { subject.permission = :do_something }

    describe "and there is no user" do
      it "fails the security check" do
        fail_security_check
      end

    end

    describe "and there is a user" do
      before { subject.user = user }

      describe "with the given permission" do
        before { user.stubs(:can).with(:do_something).returns(true) }

        it "passes the security check" do
          subject.check_security!
        end
      end

      describe "without the given permission" do
        before { user.stubs(:can).with(:do_something).returns(false) }

        it "fails the security check" do
          fail_security_check
        end
      end
    end
  end

  let(:user) { mock 'User' }

  def fail_security_check
    begin
      subject.check_security!
      flunk
    rescue Marina::Commands::Unauthorised
      # expected
    end
  end
end
