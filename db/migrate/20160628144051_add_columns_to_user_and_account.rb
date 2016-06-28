class AddColumnsToUserAndAccount < ActiveRecord::Migration
  def change
    add_column :users, :order_role, :integer, default: 1
  end
end
