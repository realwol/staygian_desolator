class AddResponserToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :responser, :integer, after: :user_id
  end
end
