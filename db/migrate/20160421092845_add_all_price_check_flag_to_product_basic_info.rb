class AddAllPriceCheckFlagToProductBasicInfo < ActiveRecord::Migration
  def change
    add_column :product_basic_infos, :america_price_change, :boolean
    add_column :product_basic_infos, :canada_price_change, :boolean
    add_column :product_basic_infos, :british_price_change, :boolean
    add_column :product_basic_infos, :germany_price_change, :boolean
    add_column :product_basic_infos, :france_price_change, :boolean
    add_column :product_basic_infos, :spain_price_change, :boolean
    add_column :product_basic_infos, :italy_price_change, :boolean
  end
end
