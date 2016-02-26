class AddRetryFlagForShopLink < ActiveRecord::Migration
  def change
    add_column :shop_links, :link_retry, :boolean, default: false
  end
end
