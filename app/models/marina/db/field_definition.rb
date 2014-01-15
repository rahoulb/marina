class Marina::Db::FieldDefinition < ActiveRecord::Base
  include Marina::FieldDefinition

  serialize :options, Array

  class ShortText < Marina::Db::FieldDefinition

  end

  class LongText < Marina::Db::FieldDefinition

  end

  class Select < Marina::Db::FieldDefinition

  end

  class MultiSelect < Marina::Db::FieldDefinition
    def matches member, values
      multi_select_match member, values
    end
  end

end
