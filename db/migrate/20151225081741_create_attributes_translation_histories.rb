class CreateAttributesTranslationHistories < ActiveRecord::Migration
  def change
    create_table :attributes_translation_histories do |t|
      t.string :attribute_name
      t.string :america
      t.string :canada
      t.string :british
      t.string :germay
      t.string :spain
      t.string :italy
      t.string :france
      t.integer :attribute_id

      t.timestamps null: false
    end
  end
end
