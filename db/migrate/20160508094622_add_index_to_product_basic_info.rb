class AddIndexToProductBasicInfo < ActiveRecord::Migration
  def change
    add_index :product_basic_infos, :sku
  end
end
