class AddBackupForAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :backup, :string
  end
end
