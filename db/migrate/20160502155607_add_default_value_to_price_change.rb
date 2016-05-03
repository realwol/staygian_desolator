class AddDefaultValueToPriceChange < ActiveRecord::Migration
  def change
    change_column :product_basic_infos, :america_price_change, :boolean, default: true
    change_column :product_basic_infos, :canada_price_change, :boolean, default: true
    change_column :product_basic_infos, :british_price_change, :boolean, default: true
    change_column :product_basic_infos, :germany_price_change, :boolean, default: true
    change_column :product_basic_infos, :france_price_change, :boolean, default: true
    change_column :product_basic_infos, :spain_price_change, :boolean, default: true
    change_column :product_basic_infos, :italy_price_change, :boolean, default: true
   end
end
