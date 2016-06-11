class AddStatusToRoleAuthRelation < ActiveRecord::Migration
  def change
    add_column :role_auth_relations, :status, :boolean, default: true, after: :auth_list_id
    add_column :users, :user_product_version, :string , default: '1', after: :leader_id
    add_column :auth_lists, :auth_url, :string, after: :name
  end
end
