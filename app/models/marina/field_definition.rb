require 'active_support/core_ext/object/blank'

module Marina
  module FieldDefinition
    def kind
      case self.type
      when 'Marina::Db::FieldDefinition::ShortText' then 'short_text'
      when 'Marina::Db::FieldDefinition::LongText' then 'long_text'
      when 'Marina::Db::FieldDefinition::Select' then 'drop_down'
      when 'Marina::Db::FieldDefinition::MultiSelect' then 'multi_select'
      end
    end

    def kind= value
      self.options = [] if self.options.nil?
      self.type = case value
      when 'short_text' then 'Marina::Db::FieldDefinition::ShortText'
      when 'long_text' then 'Marina::Db::FieldDefinition::LongText'
      when 'drop_down' then 'Marina::Db::FieldDefinition::Select'
      when 'multi_select' then 'Marina::Db::FieldDefinition::MultiSelect'
      end
    end
  end
end
