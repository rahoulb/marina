class Marina::Db::Member < ActiveRecord::Base
  validates :last_name, presence: true
  validates :email, presence: true

  has_many :subscriptions, class_name: 'Marina::Db::Subscription', foreign_key: 'member_id', dependent: :destroy
end
