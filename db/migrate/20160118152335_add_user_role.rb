class AddUserRole < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, after: :email
    add_column :users, :manager, :integer, after: :email, default: 1
  end
end
