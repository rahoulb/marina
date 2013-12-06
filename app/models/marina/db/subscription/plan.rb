class Marina::Db::Subscription::Plan < ActiveRecord::Base
  validates :name, presence: true

  has_many :subscribers, class_name: 'Marina::Db::Subscription', foreign_key: 'plan_id', dependent: :destroy
  has_many :members, through: :subscribers

  scope :in_order, -> { order(:name) }
end
