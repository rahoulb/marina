require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../app/models/marina/subscription/reviewed_plan'

describe Marina::Subscription::ReviewedPlan do
  subject { plan_class.new applications }

  before { subject.stubs(:auto_approval_code).returns('KEY') }

  describe "when a new member applies" do
    describe "without an auto-approval code" do
      it "records the application" do
        subject.applications.expects(:create!).with(member: member, supporting_information: 'Info', status: 'awaiting_review', affiliate_organisation: nil, affiliate_membership_details: nil)

        subject.new_application_from(member, supporting_information: 'Info')
      end
    end

    describe "with an auto-approval code" do
      describe "that is correct" do
        it "automatically approves the application" do
          subject.applications.expects(:create!).with(member: member, supporting_information: 'Info', status: 'approved', affiliate_organisation: nil, affiliate_membership_details: nil)

          subject.new_application_from(member, supporting_information: 'Info', auto_approval_code: 'KEY')
        end
      end

      describe "that is incorrect" do
        it "does not approve the application" do
          subject.applications.expects(:create!).with(member: member, supporting_information: 'Info', status: 'awaiting_review', affiliate_organisation: nil, affiliate_membership_details: nil)

          subject.new_application_from(member, supporting_information: 'Info', auto_approval_code: 'WRONGKEY')
        end
      end
    end

    describe "with an affiliated organisation" do
      it "records the affiliation details" do
        subject.applications.expects(:create!).with(member: member, supporting_information: 'Info', status: 'awaiting_review', affiliate_organisation: affiliate_organisation, affiliate_membership_details: '123')

        subject.new_application_from(member, supporting_information: 'Info', affiliate_organisation: affiliate_organisation, affiliate_membership_details: '123')

      end

      let(:affiliate_organisation) { stub 'Affiliate Organisation' }
    end
  end

  let(:member) { stub 'Member' }
  let(:applications) { stub 'Applications' }
  let(:plan_class) do
    Class.new(Struct.new(:applications)) do
      include Marina::Subscription::ReviewedPlan
    end
  end
end
