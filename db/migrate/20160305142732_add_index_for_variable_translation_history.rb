class AddIndexForVariableTranslationHistory < ActiveRecord::Migration
  def change
    add_index :variable_translate_histories, :variable_from
  end
end
