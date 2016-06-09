class AddBrandIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :brand_id, :string, after: :shop_id
  end
end
