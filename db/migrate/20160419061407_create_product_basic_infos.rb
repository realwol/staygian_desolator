class CreateProductBasicInfos < ActiveRecord::Migration
  def change
    create_table :product_basic_infos do |t|
      t.string :sku
      t.float :price
      t.integer :inventory
      t.references :product, index: true
      t.references :variable, index: true

      t.timestamps null: false
    end
    add_foreign_key :product_basic_infos, :products
    add_foreign_key :product_basic_infos, :variables
  end
end
