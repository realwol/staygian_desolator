class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.references :user, index: true
      t.string :platform
      t.boolean :status, default: true

      t.timestamps null: false
    end
    add_foreign_key :accounts, :users
  end
end
