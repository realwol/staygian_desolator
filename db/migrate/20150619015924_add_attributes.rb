class AddAttributes < ActiveRecord::Migration
  def change
  	add_column :products, :department_name, :string
  	add_column :products, :style_name, :string
  	add_column :products, :leather_type, :string
  	add_column :products, :shaft_height, :string
  	add_column :products, :shaft_diameter, :string
  	add_column :products, :platform_height, :string
  	add_column :products, :shoe_width, :string
  	add_column :products, :lining_description, :string
  	add_column :products, :strap_type, :string
  end
end
