class AddSellerSkuToVariable < ActiveRecord::Migration
  def change
    add_column :variables, :seller_sku, :string
  end
end
