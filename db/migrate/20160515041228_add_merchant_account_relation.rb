class AddMerchantAccountRelation < ActiveRecord::Migration
  def change
    add_column :merchants, :account_id, :integer, after: :user_id
  end
end
