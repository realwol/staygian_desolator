class AddStatusForRoleAndAuth < ActiveRecord::Migration
  def change
    add_column :auth_lists, :status, :boolean, after: :name, default: true
    add_column :roles, :status, :boolean, after: :name, default: true
  end
end
