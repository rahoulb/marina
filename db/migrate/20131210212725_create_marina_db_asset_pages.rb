class CreateMarinaDbAssetPages < ActiveRecord::Migration
  def change
    create_table :marina_db_asset_pages do |t|
      t.belongs_to :site
      t.string :type, length: 128
      t.string :name, length: 64
      t.text :contents
      t.integer :position
      t.timestamps
    end
    add_index :marina_db_asset_pages, [:site_id, :name], unique: true
  end
end
