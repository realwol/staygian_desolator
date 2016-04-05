class CreateMerchantSkuRelations < ActiveRecord::Migration
  def change
    create_table :merchant_sku_relations do |t|
      t.integer :merchant_id
      t.integer :product_id
      t.string :sku

      t.timestamps null: false
    end
  end
end
