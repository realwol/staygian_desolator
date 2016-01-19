class AddVariableTranslatioinFrom < ActiveRecord::Migration
  def change
    add_column :variable_translate_histories, :variable_from, :string
  end
end
