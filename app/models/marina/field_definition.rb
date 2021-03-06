require 'active_support/core_ext/object/blank'

module Marina
  module FieldDefinition
    def kind
      case self.type
      when 'Marina::Db::FieldDefinition::ShortText' then 'short_text'
      when 'Marina::Db::FieldDefinition::LongText' then 'long_text'
      when 'Marina::Db::FieldDefinition::Select' then 'drop_down'
      when 'Marina::Db::FieldDefinition::MultiSelect' then 'multi_select'
      when 'Marina::Db::FieldDefinition::Boolean' then 'checkbox'
      when 'Marina::Db::FieldDefinition::Date' then 'date'
      end
    end

    def kind= value
      self.options = [] if self.options.nil?
      self.type = case value
      when 'short_text' then 'Marina::Db::FieldDefinition::ShortText'
      when 'long_text' then 'Marina::Db::FieldDefinition::LongText'
      when 'drop_down' then 'Marina::Db::FieldDefinition::Select'
      when 'multi_select' then 'Marina::Db::FieldDefinition::MultiSelect'
      when 'checkbox' then 'Marina::Db::FieldDefinition::Boolean'
      when 'date' then 'Marina::Db::FieldDefinition::Date'
      end
    end

    # these matchers are used by sub-classes.
    # ought to move these into their own modules
    def text_field_match member, value
      member.data[self.name].to_s == value.to_s
    end

    def boolean_match member, value
      value = (value == true) || (value.to_s.downcase == 'true') || (value == 1) || (value == '1')
      member.data[self.name] == value
    end

    def multi_select_match member, values
      selected = member.data[self.name]
      return false if selected.blank?
      values = values.split(',')
      values.each do | value |
        return false unless selected.include? value.strip
      end
      return true
    end

    def date_match member, value
      member.data[self.name] == value
    end
  end
end
