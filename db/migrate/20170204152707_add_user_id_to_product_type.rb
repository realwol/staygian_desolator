class AddUserIdToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :user_id, :string
  end
end
