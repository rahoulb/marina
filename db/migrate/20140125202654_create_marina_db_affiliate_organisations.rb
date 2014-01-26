class CreateMarinaDbAffiliateOrganisations < ActiveRecord::Migration
  def change
    create_table :marina_db_affiliate_organisations do |t|
      t.belongs_to :site
      t.string :name, length: 64, default: '', null: false
      t.decimal :discount, precision: 8, scale: 2, default: 0.0, null: false
      t.boolean :applies_to_memberships, :applies_to_tickets, default: false, null: false
      t.timestamps
    end
  end
end
