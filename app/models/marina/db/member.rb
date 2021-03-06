class Marina::Db::Member < ActiveRecord::Base
  include Marina::Member

  attr_accessor :password, :password_confirmation, :agrees_to_terms

  validates :last_name, presence: true
  validates :email, presence: true
  validates :password, confirmation: true

  has_many :mailouts_received, class_name: 'Marina::Db::Mailout::Delivery', foreign_key: 'member_id', dependent: :destroy
  has_many :subscriptions, class_name: 'Marina::Db::Subscription', foreign_key: 'member_id', dependent: :destroy
  has_many :log_entries, -> { order('created_at desc') }, class_name: 'Marina::Db::LogEntry', as: :owner, dependent: :destroy
  has_many :plan_applications, class_name: 'Marina::Db::Subscription::ReviewedPlan::Application', foreign_key: 'member_id', dependent: :destroy

  scope :with_directory_listing, -> { where(has_directory_listing: true) }
  scope :mailshot_receivers, -> { where(receives_mailshots: true) }
  scope :visible_to_all, -> { where(visible_to: 'all') }
  scope :visible_to_members, -> { where('visible_to = ? or visible_to = ?', 'all', 'some') }
  scope :by_last_name, -> (last_name) { where('last_name like ?', "#{last_name}%") }
  scope :all_latest_members, -> { order(:created_at) }
  scope :latest_members, -> (count) { order('created_at asc').limit(count) }

  before_save :encrypt_password
  before_save :generate_payment_processor_id
  before_create :generate_api_token
  after_save :update_directory_listing

  serialize :permissions, Array
  serialize :data, Hash
  serialize :visible_plans, Array

  def current_subscription
    subscriptions.active.first
  end

  def field_definition_names
    Marina::Db::FieldDefinition.names
  end

  class << self
    def by_username username
      where(username: username).first
    end

    def encryption_strategy
      SHA256Encryptor.new
    end

    def renewal_due_in_two_weeks
      find_members_with_renewals_due_on(Date.today + 14)
    end

    def renewal_due_in_four_weeks
      find_members_with_renewals_due_on(Date.today + 28)
    end

    protected

    def find_members_with_renewals_due_on date
      results = []
      find_each do | member |
        results << member if !member.current_subscription.nil? && member.current_subscription.expires_on.to_date == date
      end
      return results
    end

  end

  class SHA256Encryptor
    def encrypt password
      Digest::SHA256.hexdigest password.to_s
    end
  end
end
