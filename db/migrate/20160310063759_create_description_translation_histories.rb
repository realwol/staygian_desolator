class CreateDescriptionTranslationHistories < ActiveRecord::Migration
  def change
    create_table :description_translation_histories do |t|
      t.text :description
      t.text :china
      t.text :america
      t.text :canada
      t.text :british
      t.text :germany
      t.text :spain
      t.text :italy
      t.text :france

      t.timestamps null: false
    end
  end
end
