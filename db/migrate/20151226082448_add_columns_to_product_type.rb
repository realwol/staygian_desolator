class AddColumnsToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :shipment_translation, :integer
    add_column :product_types, :price_translation, :integer
    add_column :product_types, :product_type_description, :integer
    add_column :product_types, :product_type_feed, :integer
    add_column :product_types, :product_type_1, :integer
    add_column :product_types, :product_type_2, :integer
    add_column :product_types, :product_type_introduction_1, :integer
    add_column :product_types, :product_type_introduction_2, :integer
  end
end
