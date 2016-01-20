class AddProductTypeNameTransationToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :key_word1_translation, :integer
    add_column :product_types, :key_word2_translation, :integer
    add_column :product_types, :key_word3_translation, :integer
    add_column :product_types, :key_word4_translation, :integer
    add_column :product_types, :key_word5_translation, :integer
  end
end
