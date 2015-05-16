class AddShopNameToShopLink < ActiveRecord::Migration
  def change
  	rename_column :shop_links, :shop_id, :shop_id_string
  	add_column :shop_links, :shop_id, :string
  end
end
