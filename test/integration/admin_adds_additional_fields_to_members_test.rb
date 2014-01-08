require_relative "../test_helper"

describe "AdminAddsAdditionalFieldsToMembers Integration Test" do

  describe "when logged in as an administrator" do
    it "adds a short text field"
    it "adds a long text field"
    it "adds a drop-down field with options"
    it "adds a multi-select field with options"

    let(:admin) { a_saved Marina::Db::Member, admin: true }
  end

  describe "when logged in as a non-administrator" do
    before do
      login_as member
    end

    it "is not allowed" do
      post "/api/field_definitions", name: 'test', label: 'Test field', kind: 'short_text', format: 'json'

      response.status.must_equal 401
    end

    let(:member) { a_saved Marina::Db::Member, username: 'member', password: 'secret', password_confirmation: 'secret', admin: false }
  end

  describe "when not logged in" do
    it "is not allowed" do
      post "/api/field_definitions", name: 'test', label: 'Test field', kind: 'short_text', format: 'json'

      response.status.must_equal 401
    end
  end

end
