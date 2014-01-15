require_relative "../test_helper"

describe "VisitorSearchesMembersDirectory Integration Test" do

  it "finds the latest members with no privacy settings" do
    setup_members
    find_latest_members
    verify_latest_members
  end

  it "finds members with no privacy settings by their surname" do
    setup_members
    @members = find_members_called 'Smith'
    verify_by_surname @members, 'Smith'
  end

  it "finds members with no privacy settings by a letter in their surname" do
    setup_members
    @members = find_members_starting_with 'J'
    verify_starting_with @members, 'J'
  end

  it "finds members with no privacy settings by custom multi-select fields" do
    setup_multi_select_fields
    setup_members_with_multi_select_fields
    @members = find_members_with_multi_select_values_selected
    verify_multi_select_valued @members
  end
  
  it "finds members with no privacy settings by custom drop-down fields" do
    setup_drop_down_fields
    setup_members_with_drop_down_fields
    @members = find_members_with_drop_down_values_selected
    verify_drop_down @members
  end

  it "finds members with no privacy settings by custom check-box fields" do
    setup_checkbox_fields
    setup_members_with_checkbox_fields
    @members = find_members_with_checkbox_fields_selected
    verify_checkbox @members
  end

  it "finds members with no privacy settings by custom text fields" do
    setup_text_fields
    setup_members_with_text_fields
    @members = find_members_with_text_fields_selected
    verify_text @members
  end

  def setup_members
    @do_not_find = []
    3.times do | i |
      @do_not_find << a_saved(Marina::Db::Member, visible_to: 'none')
    end
    @brown = a_saved Marina::Db::Member, visible_to: 'all', last_name: 'Brown'
    @smith = a_saved Marina::Db::Member, visible_to: 'all', last_name: 'Smith'
    @jones = a_saved Marina::Db::Member, visible_to: 'all', last_name: 'Jones'
  end

  def find_latest_members
    get "/api/members_directory/latest_members/3", format: 'json'
    response.status.must_equal 200
  end

  def verify_latest_members
    data = JSON.parse(response.body)['members']
    data.size.must_equal 3
    brown = data.find { | d | d['id'] == @brown.id }
    smith = data.find { | d | d['id'] == @smith.id }
    jones = data.find { | d | d['id'] == @jones.id }
  end
end
