require_relative "../test_helper"

describe "MemberUpgradesToAnApprovedPlan Integration Test" do
  it "applies from being a basic member" do
    given_some_plans
    given_a_basic_member
    when_i_apply_to_the_reviewed_plan
    then_my_application_should_be_recorded
  end

  it "applies from being a member on another plan" do
    given_some_plans
    given_a_member_on_another_plan
    when_i_apply_to_the_reviewed_plan
    then_my_application_should_be_recorded
  end

  def given_some_plans
    plan.touch
    other_plan.touch
  end

  def given_a_basic_member
    login_as member
  end

  def given_a_member_on_another_plan
    member.subscriptions.create! plan: other_plan, active: true, expires_on: 22.days.from_now
    login_as member
  end

  def when_i_apply_to_the_reviewed_plan
    post "/api/membership_applications", application: { plan_id: plan.id, supporting_information: 'I am great' }, format: 'json'
  end

  def then_my_application_should_be_recorded
    response.status.must_equal 201
    plan.reload
    @application = plan.applications.first
    @application.wont_equal nil
    @application.member.must_equal member
    @application.supporting_information.must_equal 'I am great'
    @application.status.must_equal 'awaiting_review'
  end

  let(:other_plan) { a_saved Marina::Db::Subscription::PaidPlan }
  let(:plan) { a_saved Marina::Db::Subscription::ReviewedPlan }
  let(:member) { a_saved Marina::Db::Member }

end
