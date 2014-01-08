require "test_helper"

describe Marina::Db::FieldDefinition do
  before do
    @field_definition = Marina::Db::FieldDefinition.new
  end

  it "must be valid" do
    @field_definition.valid?.must_equal true
  end
end
