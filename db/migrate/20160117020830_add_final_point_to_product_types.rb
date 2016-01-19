class AddFinalPointToProductTypes < ActiveRecord::Migration
  def change
    add_column :product_types, :is_final_type, :boolean, default: false
  end
end
