class CreateVariableTranslateHistories < ActiveRecord::Migration
  def change
    create_table :variable_translate_histories do |t|
      t.string :word
      t.string :en
      t.string :de
      t.string :fr
      t.string :es
      t.string :it

      t.timestamps null: false
    end
  end
end
