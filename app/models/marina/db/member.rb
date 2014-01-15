class Marina::Db::Member < ActiveRecord::Base
  include Marina::Member

  attr_accessor :password, :password_confirmation, :agrees_to_terms

  validates :last_name, presence: true
  validates :email, presence: true
  validates :password, confirmation: true

  has_many :mailouts_received, class_name: 'Marina::Db::Mailout::Delivery', foreign_key: 'member_id', dependent: :destroy
  has_many :subscriptions, class_name: 'Marina::Db::Subscription', foreign_key: 'member_id', dependent: :destroy
  has_many :log_entries, -> { order('created_at desc') }, class_name: 'Marina::Db::LogEntry', as: :owner, dependent: :destroy

  scope :mailshot_receivers, -> { where(receives_mailshots: true) }
  scope :latest_members, -> (params = {}) { where(visible_to: params[:visible_to] || 'all').order(:created_at).limit(params[:count] || 6) }

  before_save :encrypt_password
  before_create :generate_api_token

  serialize :permissions, Array
  serialize :data, Hash
  serialize :visible_plans, Array

  def current_subscription
    subscriptions.active.first
  end

  class << self
    def by_username username
      where(username: username).first
    end

    def encryption_strategy
      SHA256Encryptor.new
    end
  end

  class SHA256Encryptor
    def encrypt password
      Digest::SHA256.hexdigest password.to_s
    end
  end
end
