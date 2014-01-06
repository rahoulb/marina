class Marina::Db::Subscription::Plan < ActiveRecord::Base
  validates :name, presence: true

  has_many :subscribers, class_name: 'Marina::Db::Subscription', foreign_key: 'plan_id', dependent: :destroy
  has_many :active_subscribers, -> { where(active: true) }, class_name: 'Marina::Db::Subscription', foreign_key: 'plan_id'
  has_many :members, through: :active_subscribers

  scope :in_order, -> { order(:name) }

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
