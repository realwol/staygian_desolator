class RenameColumnsOfProduct < ActiveRecord::Migration
  def change
  	rename_column :products, :outer_material_type_uk, :outer_material_type_england
  	rename_column :products, :outer_material_type_de, :outer_material_type_germany
  	rename_column :products, :outer_material_type_fr, :outer_material_type_france
  	rename_column :products, :outer_material_type_es, :outer_material_type_spain
  	rename_column :products, :outer_material_type_it, :outer_material_type_italy
  	rename_column :products, :inner_material_type_uk, :inner_material_type_england
  	rename_column :products, :inner_material_type_de, :inner_material_type_germany
  	rename_column :products, :inner_material_type_fr, :inner_material_type_france
  	rename_column :products, :inner_material_type_es, :inner_material_type_spain
  	rename_column :products, :inner_material_type_it, :inner_material_type_italy
  	rename_column :products, :sole_material_uk, :sole_material_england
  	rename_column :products, :sole_material_de, :sole_material_germany
  	rename_column :products, :sole_material_fr, :sole_material_france
  	rename_column :products, :sole_material_es, :sole_material_spain
  	rename_column :products, :sole_material_it, :sole_material_italy
  	rename_column :products, :heel_type_uk, :heel_type_england
  	rename_column :products, :heel_type_de, :heel_type_germany
  	rename_column :products, :heel_type_fr, :heel_type_france
  	rename_column :products, :heel_type_es, :heel_type_spain
  	rename_column :products, :heel_type_it, :heel_type_italy
  	rename_column :products, :closure_type_uk, :closure_type_england
  	rename_column :products, :closure_type_de, :closure_type_germany
  	rename_column :products, :closure_type_fr, :closure_type_france
  	rename_column :products, :closure_type_es, :closure_type_spain
  	rename_column :products, :closure_type_it, :closure_type_italy
  end
end
