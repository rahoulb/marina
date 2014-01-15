class Marina::Db::FieldDefinition < ActiveRecord::Base
  include Marina::FieldDefinition

  serialize :options, Array

  class ShortText < Marina::Db::FieldDefinition
    def matches member, value
      text_field_match member, value
    end
  end

  class LongText < ShortText

  end

  class Select < ShortText

  end

  class Boolean < Marina::Db::FieldDefinition
    def matches member, value
      boolean_match member, value
    end
  end

  class MultiSelect < Marina::Db::FieldDefinition
    def matches member, values
      multi_select_match member, values
    end
  end

end
