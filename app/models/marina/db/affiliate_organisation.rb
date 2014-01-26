class Marina::Db::AffiliateOrganisation < ActiveRecord::Base
  scope :applies_to_memberships, -> { where(applies_to_memberships: true) }
  scope :applies_to_tickets, -> { where(applies_to_tickets: true) }
  
  class << self
    def called name
      where(name: name).first
    end
  end
end
