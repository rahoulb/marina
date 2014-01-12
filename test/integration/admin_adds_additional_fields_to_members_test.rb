require_relative "../test_helper"

describe "AdminAddsAdditionalFieldsToMembers Integration Test" do

  describe "when logged in with 'manage field definitions' permission" do
    before do
      login_as admin
    end

    it "adds a short text field" do
      post "/api/field_definitions", field_definition: { name: 'test', label: 'Test field', kind: 'short_text'}, format: 'json'

      response.status.must_equal 201
      data = JSON.parse(response.body)

      @field_definition = Marina::Db::FieldDefinition.where(name: 'test').first
      @field_definition.wont_equal nil
      @field_definition.label.must_equal 'Test field'
      @field_definition.kind_of?(Marina::Db::FieldDefinition::ShortText).must_equal true

      compare @field_definition, with: data

      @member = a_saved Marina::Db::Member
      @member.data['test'].must_equal nil
      @member.data['test'] = 'Hello'
      @member.save
      @member.reload
      @member.data['test'].must_equal 'Hello'
    end

    it "adds a long text field" do
      post "/api/field_definitions", field_definition: { name: 'test', label: 'Test field', kind: 'long_text'}, format: 'json'

      response.status.must_equal 201
      data = JSON.parse(response.body)

      @field_definition = Marina::Db::FieldDefinition.where(name: 'test').first
      @field_definition.wont_equal nil
      @field_definition.label.must_equal 'Test field'
      @field_definition.kind_of?(Marina::Db::FieldDefinition::LongText).must_equal true

      compare @field_definition, with: data

      @member = a_saved Marina::Db::Member
      @member.data['test'].must_equal nil
      @member.data['test'] = 'Hello'
      @member.save
      @member.reload
      @member.data['test'].must_equal 'Hello'
    end

    it "adds a drop-down field with options" do
      post "/api/field_definitions", field_definition: { name: 'test', label: 'Test field', kind: 'drop_down', options: ['this', 'that']}, format: 'json'

      response.status.must_equal 201
      data = JSON.parse(response.body)

      @field_definition = Marina::Db::FieldDefinition.where(name: 'test').first
      @field_definition.wont_equal nil
      @field_definition.label.must_equal 'Test field'
      @field_definition.kind_of?(Marina::Db::FieldDefinition::Select).must_equal true
      @field_definition.options.must_equal ['this', 'that']

      compare @field_definition, with: data

      @member = a_saved Marina::Db::Member
      @member.data['test'].must_equal nil
      @member.data['test'] = 'this'
      @member.save
      @member.reload
      @member.data['test'].must_equal 'this'
    end

    it "adds a multi-select field with options" do
      post "/api/field_definitions", field_definition: { name: 'test', label: 'Test field', kind: 'multi_select', options: ['this', 'that']}, format: 'json'

      response.status.must_equal 201
      data = JSON.parse(response.body)

      @field_definition = Marina::Db::FieldDefinition.where(name: 'test').first
      @field_definition.wont_equal nil
      @field_definition.label.must_equal 'Test field'
      @field_definition.kind_of?(Marina::Db::FieldDefinition::MultiSelect).must_equal true
      @field_definition.options.must_equal ['this', 'that']

      compare @field_definition, with: data

      @member = a_saved Marina::Db::Member
      @member.data['test'].must_equal nil
      @member.data['test'] = ['this']
      @member.save
      @member.reload
      @member.data['test'].must_equal ['this']
    end

    let(:admin) { a_saved Marina::Db::Member, permissions: ['manage_field_definitions'] }

    def compare field_definition, params
      data = params[:with]
      data["id"].must_equal field_definition.id
      data["name"].must_equal field_definition.name
      data["label"].must_equal field_definition.label
      data["kind"].must_equal field_definition.kind
      data["options"].must_equal field_definition.options
    end
  end

  describe "when logged in without 'manage field definitions' permission" do
    before do
      login_as member
    end

    it "is not allowed" do
      post "/api/field_definitions", field_definition: { name: 'test', label: 'Test field', kind: 'short_text'}, format: 'json'

      response.status.must_equal 401
    end

    let(:member) { a_saved Marina::Db::Member, username: 'member', password: 'secret', password_confirmation: 'secret', permissions: [] }
  end

  describe "when not logged in" do
    it "is not allowed" do
      post "/api/field_definitions", field_definition: { name: 'test', label: 'Test field', kind: 'short_text'}, format: 'json'

      response.status.must_equal 401
    end
  end

end
