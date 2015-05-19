class AddCheckStatusInShop < ActiveRecord::Migration
  def change
  	add_column :shop_links, :check_status, :boolean, default: true
  	add_column :shops, :check_status, :boolean, default: true
  end
end
