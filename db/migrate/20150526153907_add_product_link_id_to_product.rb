class AddProductLinkIdToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :product_link_id, :string
  end
end
