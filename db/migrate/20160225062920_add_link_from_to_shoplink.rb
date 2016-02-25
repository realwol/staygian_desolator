class AddLinkFromToShoplink < ActiveRecord::Migration
  def change
    add_column :shop_links, :link_from, :string
  end
end
