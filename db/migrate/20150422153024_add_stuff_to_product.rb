class AddStuffToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :outer_material_type, :string
  	add_column :products, :outer_material_type_uk, :string
  	add_column :products, :outer_material_type_de, :string
  	add_column :products, :outer_material_type_fr, :string
  	add_column :products, :outer_material_type_es, :string
  	add_column :products, :outer_material_type_it, :string
  	add_column :products, :inner_material_type, :string
  	add_column :products, :inner_material_type_uk, :string
  	add_column :products, :inner_material_type_de, :string
  	add_column :products, :inner_material_type_fr, :string
  	add_column :products, :inner_material_type_es, :string
  	add_column :products, :inner_material_type_it, :string
  	add_column :products, :sole_material, :string
  	add_column :products, :sole_material_uk, :string
  	add_column :products, :sole_material_de, :string
  	add_column :products, :sole_material_fr, :string
  	add_column :products, :sole_material_es, :string
  	add_column :products, :sole_material_it, :string
  	add_column :products, :heel_type, :string
  	add_column :products, :heel_type_uk, :string
  	add_column :products, :heel_type_de, :string
  	add_column :products, :heel_type_fr, :string
  	add_column :products, :heel_type_es, :string
  	add_column :products, :heel_type_it, :string
  	add_column :products, :closure_type, :string
  	add_column :products, :closure_type_uk, :string
  	add_column :products, :closure_type_de, :string
  	add_column :products, :closure_type_fr, :string
  	add_column :products, :closure_type_es, :string
  	add_column :products, :closure_type_it, :string
  	add_column :products, :seasons, :string
  	add_column :products, :heel_height, :string
  	add_column :products, :producer, :string
  end
end
