class ChangeStatusValue < ActiveRecord::Migration
  def change
    change_column :shop_links, :status, :boolean
  end
end
