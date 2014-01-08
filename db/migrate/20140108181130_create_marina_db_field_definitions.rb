class CreateMarinaDbFieldDefinitions < ActiveRecord::Migration
  def change
    create_table :marina_db_field_definitions do |t|
      t.belongs_to :site
      t.string :name, :label, :type, :string, length: 64, null: false
      t.text :options
      t.timestamps
    end
    add_index :marina_db_field_definitions, :site_id
  end
end
