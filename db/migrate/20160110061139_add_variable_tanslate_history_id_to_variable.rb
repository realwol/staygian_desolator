class AddVariableTanslateHistoryIdToVariable < ActiveRecord::Migration
  def change
    add_column :variables, :variable_translate_history_id, :string
  end
end
