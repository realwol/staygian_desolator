class CreateShoesAttributesValues < ActiveRecord::Migration
  def change
    create_table :shoes_attributes_values do |t|
      t.string :name
      t.string :england
      t.string :germany
      t.string :france
      t.string :spain
      t.string :italy

      t.timestamps null: false
    end
  end
end
