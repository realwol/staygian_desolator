class AddShopIdAndShopFrom < ActiveRecord::Migration
  def change
  	add_column :shops, :shop_id, :string
  	add_column :shops, :shop_from, :string
  end
end
