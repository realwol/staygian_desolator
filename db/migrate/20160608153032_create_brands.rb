class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.string :english_name
      t.string :status

      t.timestamps null: false
    end
  end
end
