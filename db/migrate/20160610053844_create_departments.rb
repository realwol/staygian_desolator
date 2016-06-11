class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.integer :parent_id
      t.string :backup

      t.timestamps null: false
    end
  end
end
