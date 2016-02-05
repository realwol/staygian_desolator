class ChangeGermayToGermany < ActiveRecord::Migration
  def change
    rename_column :attributes_translation_histories, :germay, :germany
  end
end
