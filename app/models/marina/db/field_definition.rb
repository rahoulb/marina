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

  end

end
