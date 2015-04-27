class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :product_type, index: true
      t.text :title
      t.string :sku
      t.integer :sku_number
      t.string :product_number
      t.references :user, index: true
      t.text :origin_address
      t.text :desc1
      t.text :desc2
      t.text :desc3
      t.string :brand
      t.string :price
      t.boolean :on_sale
      t.boolean :translate_status
      t.string :product_from
      t.text :details
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_foreign_key :products, :product_types
    add_foreign_key :products, :users
  end
end
