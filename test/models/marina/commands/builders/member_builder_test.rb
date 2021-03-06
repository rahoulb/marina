require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/builders/member_builder'

describe Marina::Commands::Builders::MemberBuilder do
  subject { Marina::Commands::Builders::MemberBuilder.new user: user, data_store: data_store, subscription_plans_store: plans_store, payment_processor: nil, mailing_list_processor: nil, registration_store: registration_store, affiliate_organisation_store: affiliate_organisation_store }

  it "requires no special permissions" do
    subject.permission.must_equal nil
  end

  before do
    affiliate_organisation_store.stubs(:called).returns(nil)
  end

  describe "when creating a member" do
    before do
      data_store.expects(:create!).returns(member)
      registration_store.expects(:create!).with(owner: member).returns(mock('Registration Log Entry'))
      plan.stubs(:new_application_from).returns(nil)
    end

    describe "without a subscription plan" do
      let(:params) {  { first_name: 'George', last_name: 'Testington', email: 'george@example.com', username: 'georgiou', password: 'secret101', password_confirmation: 'secret101', agrees_to_terms: true, receives_mailshots: false } }

      it "creates the member record" do
        created_member = nil
        found_plan = nil
        subject.build_from params do | member, plan |
          created_member = member
          found_plan = plan
        end
        created_member.must_equal member
        found_plan.must_equal nil
      end

      it "notifies the payment processor" do
        subject.payment_processor = payment_processor

        payment_processor.expects(:new_subscriber).with(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], plan: nil)

        subject.build_from(params) { | m, p | m }
      end

      it "notifies the mailing list processor" do
        subject.mailing_list_processor = mailing_list_processor

        mailing_list_processor.expects(:new_subscriber).with(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], plan_name: nil)

        subject.build_from(params) { | m, p | m }
      end
    end

    describe "with a paid plan" do
      let(:params) {  { first_name: 'George', last_name: 'Testington', email: 'george@example.com', username: 'georgiou', password: 'secret101', password_confirmation: 'secret101', agrees_to_terms: true, receives_mailshots: false, subscription_plan_id: plan.id } }

      before do
        plans_store.expects(:find).with(plan.id).returns(plan)
      end

      it "creates the member record" do
        created_member = nil
        found_plan = nil
        subject.build_from params do | member, plan |
          created_member = member
          found_plan = plan
        end
        created_member.must_equal member
        found_plan.must_equal plan
      end

      it "notifies the payment processor" do
        subject.payment_processor = payment_processor

        payment_processor.expects(:new_subscriber).with(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], plan: plan)

        subject.build_from(params) { | m, p | m }
      end

      it "notifies the mailing list processor" do
        subject.mailing_list_processor = mailing_list_processor

        mailing_list_processor.expects(:new_subscriber).with(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], plan_name: plan.name)

        subject.build_from(params) { | m, p | m }
      end

    end

    describe "with a reviewed plan" do
      let(:params) {  { first_name: 'George', last_name: 'Testington', email: 'george@example.com', username: 'georgiou', password: 'secret101', password_confirmation: 'secret101', agrees_to_terms: true, receives_mailshots: false, subscription_plan_id: plan.id, supporting_information: 'Hello' } }
      before do
        plans_store.expects(:find).with(plan.id).returns(plan)
      end

      describe "without using an affiliate discount" do
        before do
          plan.expects(:new_application_from).with(member, supporting_information: 'Hello').returns(application)
        end

        it "creates the member record" do
          created_member = nil
          found_plan = nil
          subject.build_from params do | member, plan |
            created_member = member
            found_plan = plan
          end
          created_member.must_equal member
          found_plan.must_equal plan
        end

        it "notifies the payment processor" do
          subject.payment_processor = payment_processor

          payment_processor.expects(:new_subscriber).with(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], plan: plan)

          subject.build_from(params) { | m, p | m }
        end

        it "notifies the mailing list processor" do
          subject.mailing_list_processor = mailing_list_processor

          mailing_list_processor.expects(:new_subscriber).with(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], plan_name: plan.name)

          subject.build_from(params) { | m, p | m }
        end
      end

      describe "with an affiliate discount" do
        it "records the affiliation details" do
          plan.expects(:new_application_from).with(member, supporting_information: 'Hello', affiliate_organisation: affiliate_organisation, affiliate_membership_details: '123').returns(application)
          affiliate_organisation_store.expects(:called).with('AffOrg').returns(affiliate_organisation)
          subject.build_from(params.merge(affiliate_organisation: 'AffOrg', affiliate_membership_details: '123')) { | m, p | m }
        end
      end

      let(:application) { stub 'Application' }
    end
  end

  let(:user) { mock 'User' }
  let(:data_store) { mock 'Members' }
  let(:plans_store) { mock 'Subscription::Plans' }
  let(:plan) { stub 'Plan', id: 123, name: 'Some plan' }
  let(:member) { mock 'Member' }
  let(:payment_processor) { mock 'Payment processor' }
  let(:mailing_list_processor) { mock 'Mailing list processor' }
  let(:registration_store) { mock 'Registration Store' }
  let(:affiliate_organisation_store) { mock 'Affiliated Organisation Store' }
  let(:affiliate_organisation) { stub 'Affiliated Organisation', discount: 25.0 }
end
