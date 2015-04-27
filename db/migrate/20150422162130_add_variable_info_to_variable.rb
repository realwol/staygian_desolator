class AddVariableInfoToVariable < ActiveRecord::Migration
  def change
  	add_column :variables, :england_color, :string
  	add_column :variables, :england_size, :string
  	add_column :variables, :germany_color, :string
  	add_column :variables, :germany_size, :string
  	add_column :variables, :france_color, :string
  	add_column :variables, :france_size, :string
  	add_column :variables, :spain_color, :string
  	add_column :variables, :spain_size, :string
  	add_column :variables, :italy_color, :string
  	add_column :variables, :italy_size, :string
  end
end
