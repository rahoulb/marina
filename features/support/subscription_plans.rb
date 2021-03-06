module SubscriptionPlans
  extend ActiveSupport::Concern

  included do

    step 'there are several subscription plans configured' do
      @premium_membership_plan = a_saved Marina::Db::Subscription::PaidPlan, name: 'Premium', price: 25.0, length: 1
      @vip_membership_plan = a_saved Marina::Db::Subscription::ReviewedPlan, name: 'VIP', price: 35.0, length: 1, supporting_information_label: 'Support your application', supporting_information_description: 'Prove it'
    end

    step 'there are members in each subscription plan' do
      @basic_member_one = a_saved Marina::Db::Member
      @basic_member_two = a_saved Marina::Db::Member

      @premium_member_one = a_saved Marina::Db::Member
      @premium_member_two = a_saved Marina::Db::Member
      @premium_subscription_one = a_saved Marina::Db::Subscription, member: @premium_member_one, plan: @premium_membership_plan
      @premium_subscription_two = a_saved Marina::Db::Subscription, member: @premium_member_two, plan: @premium_membership_plan

      @vip_member_one = a_saved Marina::Db::Member
      @vip_member_two = a_saved Marina::Db::Member
      @vip_subscription_one = a_saved Marina::Db::Subscription, member: @vip_member_one, plan: @vip_membership_plan
      @vip_subscription_two = a_saved Marina::Db::Subscription, member: @vip_member_two, plan: @vip_membership_plan

      @inactive_member_one = a_saved Marina::Db::Member
      @inactive_subscription_one = a_saved Marina::Db::Subscription, member: @inactive_member_one, plan: @premium_membership_plan, active: false, expires_on: 2.days.ago
      @inactive_member_two = a_saved Marina::Db::Member
      @inactive_subscription_two = a_saved Marina::Db::Subscription, member: @inactive_member_two, plan: @vip_membership_plan, active: false, expires_on: 2.days.ago

      @incomplete_member = a_saved Marina::Db::Member
    end

  end
end
