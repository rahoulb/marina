class Spinach::Features::ManagingSubscriptionPlans < Spinach::FeatureSteps
  include Logins
  include SubscriptionPlans
  include UiHelpers

  step 'I visit the dashboard and look at subscription plans' do
    visit '/'
    click_link I18n.t(:subscription_plans)
    wait_for 'subscription-plans', 'loaded'
  end

  step 'I should see each of the plans, along with their type and the number of members' do
    Marina::Db::Subscription::Plan.find_each do | plan |
      within "#subscription-plan-#{plan.id}" do
        page.has_content?(plan.name).must_equal true
        page.has_content?(plan.members.count).must_equal true
      end
    end
  end

  step 'I add a basic plan' do
    click_link I18n.t(:new_basic_plan)
    fill_in 'plan-name', with: 'My basic plan'
    click_button I18n.t(:save)
    wait_for 'subscription-plan', 'saved'
  end

  step 'the new basic plan should be added to the system' do
    page.has_content?('My basic plan').must_equal true
    plan = Marina::Db::Subscription::BasicPlan.where(name: 'My basic plan').first
    plan.wont_equal nil
    plan.name.must_equal 'My basic plan'
  end

  step 'I add a paid plan, including payment details and subscription length' do
    click_link I18n.t(:new_paid_plan)
    fill_in 'plan-name', with: 'My paid plan'
    fill_in 'plan-price', with: '10'
    select I18n.t(:annual), from: 'plan-length'
    click_button I18n.t(:save)
    wait_for 'subscription-plan', 'saved'
  end

  step 'the new paid plan should be added to the system' do
    page.has_content?('My paid plan').must_equal true
    plan = Marina::Db::Subscription::PaidPlan.where(name: 'My paid plan').first
    plan.wont_equal nil
    plan.name.must_equal 'My paid plan'
    plan.price.must_equal 10.0
    plan.length.must_equal 12
  end

  step 'I add an approved plan, including payment details, subscription length and supporting information' do
    click_link I18n.t(:new_reviewed_plan)
    fill_in 'plan-name', with: 'My approved plan'
    fill_in 'plan-price', with: '12.3'
    select I18n.t(:monthly), from: 'plan-length'
    fill_in 'plan-supporting-label', with: 'Please enter some more information'
    fill_in 'plan-supporting-description', with: 'Tell people about yourself'
    click_button I18n.t(:save)
    wait_for 'subscription-plan', 'saved'
  end

  step 'the new approved plan should be added to the system' do
    page.has_content?('My approved plan').must_equal true
    plan = Marina::Db::Subscription::ReviewedPlan.where(name: 'My approved plan').first
    plan.wont_equal nil
    plan.name.must_equal 'My approved plan'
    plan.price.must_equal 12.3
    plan.length.must_equal 1
    plan.supporting_information_label.must_equal 'Please enter some more information'
    plan.supporting_information_description.must_equal 'Tell people about yourself'
  end

  step 'I deactivate an existing plan' do
    click_link 'Premium'
    uncheck I18n.t(:active)
    click_button I18n.t(:save)
    wait_for 'subscription-plan', 'saved'
  end

  step 'the plan should be deactivated' do
    @premium_membership_plan.reload
    @premium_membership_plan.active.wont_equal true
  end

end
