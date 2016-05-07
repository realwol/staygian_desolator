class AddIndexToMerchantId < ActiveRecord::Migration
  def change
    add_index :merchant_sku_relations, :merchant_id
  end
end
