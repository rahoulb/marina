class Marina::Db::LogEntry < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  serialize :data
end
