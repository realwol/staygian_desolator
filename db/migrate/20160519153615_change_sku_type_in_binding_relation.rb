class ChangeSkuTypeInBindingRelation < ActiveRecord::Migration
  def change
    remove_index :merchant_sku_relations, :sku
    change_column :merchant_sku_relations, :sku, :text
    add_index :merchant_sku_relations, :sku, length: 255
  end
end
