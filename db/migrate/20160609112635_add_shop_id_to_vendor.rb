class AddShopIdToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :shop_id, :string, after: :brand_id
  end
end
