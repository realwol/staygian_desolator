class ChangeTranslationIntoText < ActiveRecord::Migration
  def change
    change_column :attributes_translation_histories, :china, :text
    change_column :attributes_translation_histories, :america, :text
    change_column :attributes_translation_histories, :canada, :text
    change_column :attributes_translation_histories, :british, :text
    change_column :attributes_translation_histories, :germany, :text
    change_column :attributes_translation_histories, :spain, :text
    change_column :attributes_translation_histories, :italy, :text
    change_column :attributes_translation_histories, :france, :text
  end
end
