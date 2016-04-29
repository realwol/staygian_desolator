class AddVariableDescTranslation < ActiveRecord::Migration
  def change
    # add_column :variables, :desc_translation_id, :integer
    add_column :variables, :en, :text
    add_column :variables, :de, :text
    add_column :variables, :fr, :text
    add_column :variables, :es, :text
    add_column :variables, :it, :text
  end
end
