class Marina::Db::Mailout < ActiveRecord::Base
  include Marina::Mailout
  belongs_to :sender, class_name: 'Marina::Db::Member', foreign_key: 'sender_id', touch: true
  has_many :deliveries, class_name: 'Marina::Db::Mailout::Delivery', foreign_key: 'mailout_id', dependent: :destroy

  serialize :recipient_plan_ids, Array

  validates :subject, presence: true

  before_save :set_from_address

  def record_delivery_to member
    deliveries.create! member: member unless self.test
  end

end
