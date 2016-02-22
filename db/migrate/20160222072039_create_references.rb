class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.string :key1
      t.string :key2
      t.string :key3
      t.text :value
      t.boolean :is_using, default: true

      t.timestamps null: false
    end
  end
end
