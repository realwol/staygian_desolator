class AddRoleAndDepartmentToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_role_id, :string, after: :role
    add_column :users, :department_id, :string, after: :role
    add_column :users, :leader_id, :string, after: :role
  end
end
