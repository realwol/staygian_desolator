class CreateSearchLinks < ActiveRecord::Migration
  def change
    create_table :search_links do |t|
      t.text :link
      t.text :grasp_shop_id
      t.text :forbidden_words
      t.text :link_desc
      t.text :backup
      t.references :user, index: true
      t.boolean :status
      t.boolean :check_status

      t.timestamps null: false
    end
    add_foreign_key :search_links, :users
  end
end
