class AddShopToTmallLinkAndProduct < ActiveRecord::Migration
  def change
  	add_column :products, :shop_id, :string
  	add_column :tmall_links, :shop_id, :string
  end
end
