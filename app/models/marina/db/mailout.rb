class Marina::Db::Mailout < ActiveRecord::Base
  include Marina::Mailout
  belongs_to :sender, class_name: 'Marina::Db::Member', foreign_key: 'sender_id', touch: true

  serialize :recipient_plan_ids, Array

  validates :subject, presence: true

  before_save :set_from_address

end
