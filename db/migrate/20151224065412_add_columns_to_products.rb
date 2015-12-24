class AddColumnsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :purchase_link, :text
    add_column :products, :product_weight, :string
    add_column :products, :editing_backup, :text
  end
end
