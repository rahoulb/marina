require_relative '../test_helper'
require_relative '../support/field_helpers'

describe "MemberSearchesMembersDirectory Integration Test" do
  include Test::FieldHelpers

  before do
    subscription.touch # ensure the subscription is created
    login_as member
  end

  it "finds the latest members with matching privacy settings" do
    setup_members
    find_latest_members
    verify_latest_members
  end

  it "finds members with matching privacy settings by their last name" do
    setup_members
    find_members_called 'Smith'
    verify_by_last_name
  end

  it "finds members with matching privacy settings by a letter in their last name" do
    setup_members
    find_members_starting_with 'J'
    verify_by_starting_letter
  end

  it "finds members with matching privacy settings by custom multi-select fields" do
    setup_multi_select_fields
    setup_members_with_multi_select_fields
    find_members_with_multi_select_values_selected
    verify_filtered_members
  end
  
  it "finds members with matching privacy settings by custom drop-down fields" do
    setup_drop_down_fields
    setup_members_with_drop_down_fields
    find_members_with_drop_down_values_selected
    verify_filtered_members
  end

  it "finds members with matching privacy settings by custom check-box fields" do
    setup_checkbox_fields
    setup_members_with_checkbox_fields
    find_members_with_checkbox_fields_selected
    verify_filtered_members
  end

  it "finds members with matching privacy settings by custom text fields" do
    setup_text_fields
    setup_members_with_text_fields
    find_members_with_text_fields_selected
    verify_filtered_members
  end

  let(:data) { JSON.parse(response.body)['members'] }
  let(:standard_plan) { a_saved Marina::Db::Subscription::PaidPlan }
  let(:premium_plan) { a_saved Marina::Db::Subscription::PaidPlan }
  let(:member) { a_saved Marina::Db::Member }
  let(:subscription) { a_saved Marina::Db::Subscription, member: member, plan: standard_plan }

  def setup_members
    @do_not_find = []
    @do_not_find << a_saved(Marina::Db::Member, visible_to: 'none', last_name: 'Hidden', has_directory_listing: true)
    @do_not_find << a_saved(Marina::Db::Member, visible_to: 'some', visible_plans: [premium_plan.id], has_directory_listing: true)
    @do_not_find << a_saved(Marina::Db::Member, visible_to: 'all', has_directory_listing: false)

    @brown = a_saved Marina::Db::Member, visible_to: 'some', visible_plans: [standard_plan.id, premium_plan.id], last_name: 'Brown'
    @smith = a_saved Marina::Db::Member, visible_to: 'some', visible_plans: [standard_plan.id], last_name: 'Smith'
    @jones = a_saved Marina::Db::Member, visible_to: 'all', last_name: 'Jones'
  end

  def setup_members_with_multi_select_fields
    @private = a_saved Marina::Db::Member, visible_to: 'none', data: { 'first' => ['this', 'that'], 'second' => ['rock'] }
    @no_matches = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => [], 'second' => [] }
    @partial_match = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => ['this'], 'second' => ['rock'] }
    @another_partial_match = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => ['this', 'that'], 'second' => ['house'] }
    @match = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => ['this', 'that'], 'second' => ['rock'] }
  end

  def setup_members_with_drop_down_fields
    @private = a_saved Marina::Db::Member, visible_to: 'none', data: { 'first' => 'this', 'second' => 'rock' }
    @no_matches = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => '', 'second' => '' }
    @partial_match = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => 'that', 'second' => 'rock' }
    @another_partial_match = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => 'this', 'second' => 'house' }
    @match = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => 'this', 'second' => 'rock' }
  end

  def setup_members_with_text_fields
    @private = a_saved Marina::Db::Member, visible_to: 'none', data: { 'first' => 'this', 'second' => 'rock' }
    @no_matches = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => '', 'second' => '' }
    @partial_match = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => 'that', 'second' => 'rock' }
    @another_partial_match = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => 'this', 'second' => 'house' }
    @match = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => 'this', 'second' => 'rock' }
  end

  def setup_members_with_checkbox_fields
    @private = a_saved Marina::Db::Member, visible_to: 'none', data: { 'first' => true, 'second' => false }
    @no_matches = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => false, 'second' => true }
    @partial_matches = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => false, 'second' => false }
    @match = a_saved Marina::Db::Member, visible_to: 'all', data: { 'first' => true, 'second' => false }
  end

  def find_latest_members
    get "/api/members_directory/latest_members/3", format: 'json'
    response.status.must_equal 200
  end

  def find_members_called last_name
    get "/api/members_directory/members_search?last_name=#{last_name}", format: 'json'
    response.status.must_equal 200
  end

  def find_members_starting_with letter
    get "/api/members_directory/members_search?last_name=#{letter}", format: 'json'
  end

  def find_members_with_multi_select_values_selected
    get "/api/members_directory/members_search?first=this,that&second=rock", format: 'json'
  end

  def find_members_with_drop_down_values_selected
    get "/api/members_directory/members_search?first=this&second=rock", format: 'json'
  end

  def find_members_with_text_fields_selected
    get "/api/members_directory/members_search?first=this&second=rock", format: 'json'
  end

  def find_members_with_checkbox_fields_selected
    get "/api/members_directory/members_search?first=true&second=false", format: 'json'
  end

  def compare_data_for member, params
    data = params[:against]
    data['id'].must_equal member.id
    data['username'].must_equal member.username
    data['email'].must_equal member.email
    data['firstName'].must_equal member.first_name
    data['lastName'].must_equal member.last_name
    data['name'].must_equal member.name
    data['subscriptionPlan'].must_equal member.subscription_plan
    data['subscriptionActive'].must_equal member.subscription_active
  end

  def verify_latest_members
    data.size.must_equal 3
    brown = data.find { | d | d['id'] == @brown.id }
    compare_data_for @brown, against: brown
    smith = data.find { | d | d['id'] == @smith.id }
    compare_data_for @smith, against: smith
    jones = data.find { | d | d['id'] == @jones.id }
    compare_data_for @jones, against: jones
  end

  def verify_by_last_name
    data.size.must_equal 1
    compare_data_for @smith, against: data.first
  end

  def verify_by_starting_letter
    data.size.must_equal 1
    compare_data_for @jones, against: data.first
  end

  def verify_filtered_members
    data.size.must_equal 1
    compare_data_for @match, against: data.first
  end
end
