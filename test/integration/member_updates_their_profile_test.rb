require_relative "../test_helper"

describe "MemberUpdatesTheirProfile Integration Test" do
  describe "when not logged in" do
    it "is not allowed" do
      when_i_update_my_basic_fields
      then_it_should_not_be_allowed
    end
  end

  describe "when logged in as a member without an active subscription" do
    before { login_as member }

    it "can update basic fields" do
      when_i_update_my_basic_fields
      then_the_update_should_happen
      then_my_basic_fields_should_be_updated
    end

    it "cannot update standard fields" do
      when_i_update_my_standard_fields
      then_the_update_should_happen
      then_my_standard_fields_should_not_be_updated
    end

    it "cannot update custom fields" do
      given_some_custom_fields
      when_i_update_my_custom_fields
      then_the_update_should_happen
      then_my_custom_fields_should_not_be_updated
    end

  end

  describe "when logged in as a member with an active subscription" do
    before do
      member.subscriptions.create! plan: plan, active: true
      login_as member
    end

    it "can update basic fields" do
      when_i_update_my_basic_fields
      then_the_update_should_happen
      then_my_basic_fields_should_be_updated
    end

    it "can update standard fields" do
      when_i_update_my_standard_fields
      then_the_update_should_happen
      then_my_standard_fields_should_be_updated
    end

    it "can update custom fields" do
      given_some_custom_fields
      when_i_update_my_custom_fields
      then_the_update_should_happen
      then_my_custom_fields_should_be_updated
    end

  end

  describe "when logged in as a member with access all members permission" do
    before do
      member.update_attribute :permissions, ["access_all_members"]
      login_as member
    end

    it "can update basic fields" do
      when_i_update_my_basic_fields
      then_the_update_should_happen
      then_my_basic_fields_should_be_updated
    end

    it "can update standard fields" do
      when_i_update_my_standard_fields
      then_the_update_should_happen
      then_my_standard_fields_should_be_updated
    end

    it "can update custom fields" do
      given_some_custom_fields
      when_i_update_my_custom_fields
      then_the_update_should_happen
      then_my_custom_fields_should_be_updated
    end

  end

  def given_some_custom_fields
    field_definition.save!
  end

  def when_i_update_my_basic_fields
    patch "/api/profile", member: { username: 'admiral', password: 'secret', password_confirmation: 'secret', email: 'admiral@example.com', first_name: 'Admiral', last_name: 'Nielson', title: 'Lord' }, format: 'json'
  end

  def when_i_update_my_standard_fields
    patch "/api/profile", member: { biography: 'boom', address: '123 Fake Street', town: 'Springfield', county: 'Yorkshire', postcode: 'X1', country: 'England', telephone: '123', web_address: 'http://example.com' }, format: 'json'
  end

  def when_i_update_my_custom_fields
    patch "/api/profile", member: { extra: 'data' }, format: 'json'
  end

  def then_it_should_not_be_allowed
    response.status.must_equal 401
  end

  def then_the_update_should_happen
    response.status.must_equal 200
  end

  def then_my_basic_fields_should_be_updated
    member.reload
    member.username.must_equal 'admiral'
    member.email.must_equal 'admiral@example.com'
    member.first_name.must_equal 'Admiral'
    member.last_name.must_equal 'Nielson'
    member.title.must_equal 'Lord'
    member.verify_password('secret').must_equal true
  end

  def then_my_standard_fields_should_not_be_updated
    member.reload
    member.biography.wont_equal 'boom'
    member.address.wont_equal '123 Fake Street'
    member.town.wont_equal 'Springfield'
    member.county.wont_equal 'Yorkshire'
    member.country.wont_equal 'England'
    member.postcode.wont_equal 'X1'
    member.telephone.wont_equal '123'
    member.web_address.wont_equal 'http://example.com'
  end

  def then_my_standard_fields_should_be_updated
    member.reload
    member.biography.must_equal 'boom'
    member.address.must_equal '123 Fake Street'
    member.town.must_equal 'Springfield'
    member.county.must_equal 'Yorkshire'
    member.country.must_equal 'England'
    member.postcode.must_equal 'X1'
    member.telephone.must_equal '123'
    member.web_address.must_equal 'http://example.com'
  end

  def then_my_custom_fields_should_not_be_updated
    member.reload
    member.data['extra'].wont_equal 'data'
  end

  def then_my_custom_fields_should_be_updated
    member.reload
    member.data['extra'].must_equal 'data'
  end

  let(:member) { a_saved Marina::Db::Member, username: 'horatio', password: 'nelson', password_confirmation: 'nelson', email: 'horatio@example.com', first_name: 'Horatio', last_name: 'Nelson', title: 'Mr'}
  let(:plan) { a_saved Marina::Db::Subscription::PaidPlan }
  let(:field_definition) { a_saved Marina::Db::FieldDefinition, name: 'extra', label: 'Extra', kind: 'short_text' }
end
