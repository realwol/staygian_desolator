class CreateTmallLinks < ActiveRecord::Migration
  def change
    create_table :tmall_links do |t|
      t.text :address
      t.boolean :status
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :tmall_links, :users
  end
end
