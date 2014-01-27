class Marina::Db::Subscription < ActiveRecord::Base
  belongs_to :plan, class_name: 'Marina::Db::Subscription::Plan', touch: true
  belongs_to :member, class_name: 'Marina::Db::Member', touch: true

  scope :active, -> { where(active: true).order(:expires_on) }

  delegate :name, to: :plan
  delegate :has_directory_listing, to: :plan

  after_save :update_directory_listing

  protected

  def update_directory_listing
    member.update_directory_listing unless member.nil?
  end
end
