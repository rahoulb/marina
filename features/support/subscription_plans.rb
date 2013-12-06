module SubscriptionPlans
  extend ActiveSupport::Concern

  included do

    step 'there are several subscription plans configured' do
      @basic_membership_plan = a_saved Marina::Db::Subscription::BasicPlan, name: 'Basic'
      @premium_membership_plan = a_saved Marina::Db::Subscription::PaidPlan, name: 'Premium'
      @vip_membership_plan = a_saved Marina::Db::Subscription::ReviewedPlan, name: 'VIP'
    end

    step 'there are members in each subscription plan' do
      @basic_member_one = a_saved Marina::Db::Member
      @basic_member_two = a_saved Marina::Db::Member
      @basic_subscription_one = a_saved Marina::Db::Subscription, member: @basic_member_one, plan: @basic_membership_plan
      @basic_subscription_two = a_saved Marina::Db::Subscription, member: @basic_member_two, plan: @basic_membership_plan

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
