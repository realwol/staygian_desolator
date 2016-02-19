class AddUserIdToVariable < ActiveRecord::Migration
  def change
    add_column :variable_translate_histories, :user_id, :integer
  end
end
