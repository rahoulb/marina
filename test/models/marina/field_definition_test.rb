require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../app/models/marina/field_definition'

describe Marina::FieldDefinition do
  subject { field_definition_class.new }

  describe "setting the type of the field definition" do
    describe "for short text fields" do
      it "sets the type" do
        subject.kind = 'short_text'
        subject.type.must_equal 'Marina::Db::FieldDefinition::ShortText'
      end
    end

    describe "for long text fields" do
      it "sets the type" do
        subject.kind = 'long_text'
        subject.type.must_equal 'Marina::Db::FieldDefinition::LongText'
      end
    end

    describe "for drop-down fields" do
      it "sets the type" do
        subject.kind = 'drop_down'
        subject.type.must_equal 'Marina::Db::FieldDefinition::Select'
        subject.options.must_equal []
      end
    end

    describe "for multi-select fields" do
      it "sets the type" do
        subject.kind = 'multi_select'
        subject.type.must_equal 'Marina::Db::FieldDefinition::MultiSelect'
        subject.options.must_equal []
      end
    end
  end

  describe "reading the kind of the field" do
    it "recognises short text fields" do
      subject.type = 'Marina::Db::FieldDefinition::ShortText'
      subject.kind.must_equal 'short_text'
    end
    it "recognises long text fields" do
      subject.type = 'Marina::Db::FieldDefinition::LongText'
      subject.kind.must_equal 'long_text'
    end
    it "recognises drop-down fields"  do
      subject.type = 'Marina::Db::FieldDefinition::Select'
      subject.kind.must_equal 'drop_down'
    end
    it "recognises multi-select fields"  do
      subject.type = 'Marina::Db::FieldDefinition::MultiSelect'
      subject.kind.must_equal 'multi_select'
    end
  end

  let(:field_definition_class) do
    Class.new(Struct.new(:type, :options)) do
      include Marina::FieldDefinition

    end
  end
end
