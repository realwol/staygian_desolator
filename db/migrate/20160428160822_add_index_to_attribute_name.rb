class AddIndexToAttributeName < ActiveRecord::Migration
  def change
    add_index :product_customize_attributes_relations, :attribute_name
  end
end
