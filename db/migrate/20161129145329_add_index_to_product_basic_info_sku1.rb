class AddIndexToProductBasicInfoSku1 < ActiveRecord::Migration
  def change
    add_index :product_basic_infos, :sku1
  end
end
