class Marina::Db::Subscription::Plan < ActiveRecord::Base
  validates :name, presence: true

  has_many :subscribers, class_name: 'Marina::Db::Subscription', foreign_key: 'plan_id', dependent: :destroy
  has_many :active_subscribers, -> { where(active: true) }, class_name: 'Marina::Db::Subscription', foreign_key: 'plan_id'
  has_many :members, through: :active_subscribers

  scope :in_order, -> { order(:name) }

  serialize :feature_levels, Array

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def new_application_from member, params = {}
    # do nothing
  end

  class << self
    def by_feature_level feature_level
      find_each do | plan |
        return plan if plan.feature_levels.include? feature_level
      end
      return nil
    end
  end
end
