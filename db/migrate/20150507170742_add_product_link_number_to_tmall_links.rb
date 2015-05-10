class AddProductLinkNumberToTmallLinks < ActiveRecord::Migration
  def change
  	add_column :tmall_links, :product_link_id, :string
  end
end
