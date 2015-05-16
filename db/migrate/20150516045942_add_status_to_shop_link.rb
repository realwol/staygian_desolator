class AddStatusToShopLink < ActiveRecord::Migration
  def change
  	add_column :shop_links, :status, :string
  end
end
