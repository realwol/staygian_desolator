class AddSku1ToProduct < ActiveRecord::Migration
  def change
    add_column :products, :sku1, :string, after: :sku
  end
end
