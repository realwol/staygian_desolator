class AddIndexToRelationSku < ActiveRecord::Migration
  def change
    add_index :merchant_sku_relations, :sku
    add_index :merchant_sku_relations, :product_id
  end
end
