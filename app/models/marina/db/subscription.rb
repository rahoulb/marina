class Marina::Db::Subscription < ActiveRecord::Base
  belongs_to :plan, class_name: 'Marina::Db::Subscription::Plan', touch: true
  belongs_to :member, class_name: 'Marina::Db::Member', touch: true

  scope :active, -> { where(active: true).order(:expires_on) }

  delegate :name, to: :plan
end
