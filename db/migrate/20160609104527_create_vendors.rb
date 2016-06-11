class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :name
      t.boolean :status, default: true
      t.references :brand, index: true
      t.string :purchase_address
      t.string :contact
      t.text :backup

      t.timestamps null: false
    end
    add_foreign_key :vendors, :brands
  end
end
