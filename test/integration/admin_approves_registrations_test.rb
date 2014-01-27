require_relative "../test_helper"

describe "AdminApprovesRegistrations Integration Test" do
  describe "when logged in with approval credentials" do
    before { login_as admin }

    it "lists outstanding applications" do
      given_some_outstanding_membership_applications
      when_i_view_the_applications
      then_i_should_see_the_application_details
    end

    it "marks an application as accepted" do
      given_some_outstanding_membership_applications
      given_a_payment_processor_and_mailing_list_processor
      when_i_accept_an_application
      then_the_application_should_be_approved
      then_the_member_should_receive_an_email_with_payment_details
    end

    it "marks an application as accepted but rejects the affiliations" do
      given_some_outstanding_membership_applications
      given_a_payment_processor_and_mailing_list_processor
      when_i_accept_an_application_but_reject_the_affiliation
      then_the_application_should_be_approved
      then_there_should_be_no_discount_applied
      then_the_member_should_receive_an_email_with_payment_details
    end

    it "marks an application as rejected" 

    let(:admin) { a_saved Marina::Db::Member, permissions: ['approve_membership_applications'] }
    let(:member) { a_saved Marina::Db::Member }
    let(:plan) { a_saved Marina::Db::Subscription::ReviewedPlan }
    let(:affiliate) { a_saved Marina::Db::AffiliateOrganisation, discount: 25.0 }
    let(:application) { a_saved Marina::Db::Subscription::ReviewedPlan::Application, member: member, plan: plan, supporting_information: 'I belong', status: 'awaiting_review', affiliate_organisation: affiliate, affiliate_membership_details: '123' }
    let(:approved_application) { a_saved Marina::Db::Subscription::ReviewedPlan::Application, status: 'approved' }
    let(:rejected_application) { a_saved Marina::Db::Subscription::ReviewedPlan::Application, status: 'rejected' }

    def given_some_outstanding_membership_applications
      application.touch
      approved_application.touch
      rejected_application.touch
    end

    def given_a_payment_processor_and_mailing_list_processor
      Marina::Application.config.mailing_list_processor = mailing_list_processor
      Marina::Application.config.payment_processor = payment_processor
    end

    def when_i_view_the_applications
      get "/api/membership_applications", format: 'json'
    end

    def when_i_accept_an_application
      mailing_list_processor.expects(:application_approved).with(application, payment_processor)
      payment_processor.expects(:apply_credit_to).with(member, 25.0)
      post "/api/membership_applications/#{application.id}/accept", application: { some: 'data' }, format: 'json'
    end

    def when_i_accept_an_application_but_reject_the_affiliation
      mailing_list_processor.expects(:application_approved).with(application, payment_processor)
      post "/api/membership_applications/#{application.id}/accept", application: { reason_for_affiliation_rejection: 'No way'}, format: 'json'
    end

    def then_the_application_should_be_approved
      application.reload
      application.status.must_equal 'approved'
    end

    def then_the_member_should_receive_an_email_with_payment_details
      # handled by the earlier expects on the mailing processor
    end

    def then_there_should_be_no_discount_applied
      # handled by the lack of an expects call on the payment processor
    end

    def then_i_should_see_the_application_details
      response.status.must_equal 200
      data = JSON.parse(response.body)['applications']
      data.size.must_equal 1
      data.first['id'].must_equal application.id
      data.first['status'].must_equal application.status
      data.first['plan']['id'].must_equal plan.id
      data.first['plan']['name'].must_equal plan.name
      data.first['member']['id'].must_equal member.id
      data.first['member']['name'].must_equal member.name
      data.first['supportingInformation'].must_equal 'I belong'
      data.first['affiliateMembershipDetails'].must_equal '123'
      data.first['affiliateOrganisation']['id'].must_equal affiliate.id
      data.first['affiliateOrganisation']['name'].must_equal affiliate.name
    end
  end
  
  describe "when logged in without approval credentials" do
    before { login_as member }

    it "does not list applications" do
      get "/api/membership_applications", format: 'json'
      response.status.must_equal 401
    end
    it "does not allow acceptance or rejections" do
      post "/api/membership_applications/1/accept", application: { some: 'data' }, format: 'json'
      response.status.must_equal 401
      post "/api/membership_applications/1/reject", application: { some: 'data' }, format: 'json'
      response.status.must_equal 401
    end

    let(:member) { a_saved Marina::Db::Member }
  end

  describe "when not logged in" do
    it "does not list applications" do
      get "/api/membership_applications", format: 'json'
      response.status.must_equal 401
    end

    it "does not allow acceptance or rejections" do
      post "/api/membership_applications/1/accept", application: { some: 'data' }, format: 'json'
      response.status.must_equal 401
      post "/api/membership_applications/1/reject", application: { some: 'data' }, format: 'json'
      response.status.must_equal 401
    end
  end

  let(:mailing_list_processor) { stub 'Mailing list processor' }
  let(:payment_processor) { stub 'Payment processor' }
end
