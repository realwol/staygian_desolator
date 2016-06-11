class CreateRoleAuthRelations < ActiveRecord::Migration
  def change
    create_table :role_auth_relations do |t|
      t.references :role, index: true
      t.references :auth_list, index: true

      t.timestamps null: false
    end
    add_foreign_key :role_auth_relations, :roles
    add_foreign_key :role_auth_relations, :auth_lists
  end
end
