require 'minitest/autorun'
require_relative '../../../../../app/models/marina/commands/builders/field_definition_builder'

describe Marina::Commands::Builders::FieldDefinitionBuilder do
  subject { Marina::Commands::Builders::FieldDefinitionBuilder.new }

  it "requires the :add_field_definitions permission" do
    subject.permission.must_equal :add_field_definitions
  end
end
