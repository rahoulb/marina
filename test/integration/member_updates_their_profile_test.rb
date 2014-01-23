require_relative "../test_helper"

describe "MemberUpdatesTheirProfile Integration Test" do
  describe "when not logged in" do
    it "is not allowed" do
      patch "/api/profile", member: { some: 'data' }, format: 'json'
      response.status.must_equal 401
    end
  end

  describe "when logged in as a member without an active subscription" do
    before { login_as basic_member }

    describe "accessing your own profile" do
      it "can update basic fields" do
        patch "/api/profile", member: { username: 'admiral', password: 'secret', password_confirmation: 'secret', email: 'admiral@example.com', first_name: 'Admiral', last_name: 'Nielson', title: 'Lord' }, format: 'json'
        response.status.must_equal 200

        basic_member.reload
        basic_member.username.must_equal 'admiral'
        basic_member.email.must_equal 'admiral@example.com'
        basic_member.first_name.must_equal 'Admiral'
        basic_member.last_name.must_equal 'Nielson'
        basic_member.title.must_equal 'Lord'
        basic_member.verify_password('secret').must_equal true
      end

      it "cannot update standard fields" do
        patch "/api/profile", member: { biography: 'boom', address: '123 Fake Street', town: 'Springfield', county: 'Yorkshire', postcode: 'X1', country: 'England', telephone: '123', web_address: 'http://example.com' }, format: 'json'
        response.status.must_equal 200

        basic_member.reload
        basic_member.biography.wont_equal 'boom'
        basic_member.address.wont_equal '123 Fake Street'
        basic_member.town.wont_equal 'Springfield'
        basic_member.county.wont_equal 'Yorkshire'
        basic_member.country.wont_equal 'England'
        basic_member.postcode.wont_equal 'X1'
        basic_member.telephone.wont_equal '123'
        basic_member.web_address.wont_equal 'http://example.com'
      end

      it "cannot update custom fields" do
        field_definition.save!
        patch "/api/profile", member: { extra: 'data' }, format: 'json'

        response.status.must_equal 200
        basic_member.reload
      end
    end

    describe "accessing another member's profile" do
      it "is not allowed"
    end

    let(:basic_member) { a_saved Marina::Db::Member, username: 'horatio', password: 'nelson', password_confirmation: 'nelson', email: 'horatio@example.com', first_name: 'Horatio', last_name: 'Nelson', title: 'Mr'}
    let(:field_definition) { a_saved Marina::Db::FieldDefinition, name: 'extra', label: 'Extra', kind: 'short_text' }
  end

  describe "when logged in as a member with an active subscription" do
    describe "accessing your own profile" do
      it "can update basic fields"
      it "can update standard fields"
      it "can update custom fields"
    end

    describe "accessing another member's profile" do
      it "is not allowed"
    end

  end

  describe "when logged in as a member with access all members permission" do
    describe "accessing your own profile" do
      it "can update basic fields"
      it "can update standard fields"
      it "can update custom fields"
    end

    describe "accessing another member's profile" do
      it "can update basic fields"
      it "can update standard fields"
      it "can update custom fields"
    end

  end
end
