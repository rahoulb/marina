class Marina::Db::Member < ActiveRecord::Base
  validates :last_name, presence: true
  validates :email, presence: true

  has_many :mailouts_received, class_name: 'Marina::Db::Mailout::Delivery', foreign_key: 'member_id', dependent: :destroy
  has_many :subscriptions, class_name: 'Marina::Db::Subscription', foreign_key: 'member_id', dependent: :destroy

  def can do_something
    true
  end

  def name
    "#{first_name} #{last_name}"
  end
end
