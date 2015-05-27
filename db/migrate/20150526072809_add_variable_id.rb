class AddVariableId < ActiveRecord::Migration
  def change
  	add_column :variables, :variable_id, :string
  end
end
