class ChangeColumnsToText < ActiveRecord::Migration
  def change
    change_column :product_attributes, :attribute_name, :text
    change_column :product_attributes, :table_name, :text
    change_column :attributes_translation_histories, :attribute_name, :text
  end
end
