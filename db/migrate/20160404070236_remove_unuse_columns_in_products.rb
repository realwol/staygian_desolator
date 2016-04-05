class RemoveUnuseColumnsInProducts < ActiveRecord::Migration
  def change
    remove_column :products, :outer_material_type
    remove_column :products, :outer_material_type_england
    remove_column :products, :outer_material_type_germany
    remove_column :products, :outer_material_type_france
    remove_column :products, :outer_material_type_spain
    remove_column :products, :outer_material_type_italy
    remove_column :products, :inner_material_type
    remove_column :products, :inner_material_type_england
    remove_column :products, :inner_material_type_germany
    remove_column :products, :inner_material_type_france
    remove_column :products, :inner_material_type_spain
    remove_column :products, :inner_material_type_italy
    remove_column :products, :sole_material
    remove_column :products, :sole_material_england
    remove_column :products, :sole_material_germany
    remove_column :products, :sole_material_france
    remove_column :products, :sole_material_spain
    remove_column :products, :sole_material_italy
    remove_column :products, :heel_type
    remove_column :products, :heel_type_england
    remove_column :products, :heel_type_germany
    remove_column :products, :heel_type_france
    remove_column :products, :heel_type_spain
    remove_column :products, :heel_type_italy
    remove_column :products, :closure_type
    remove_column :products, :closure_type_england
    remove_column :products, :closure_type_germany
    remove_column :products, :closure_type_france
    remove_column :products, :closure_type_spain
    remove_column :products, :closure_type_italy
  end
end
