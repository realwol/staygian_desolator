class AddDupVariableNames < ActiveRecord::Migration
  def change
  	add_column :variables, :color_dup, :string
  	add_column :variables, :size_dup, :string
  end
end
