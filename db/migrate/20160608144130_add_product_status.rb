class AddProductStatus < ActiveRecord::Migration
  def change
    add_column :tmall_links, :product_status, :string, after: :status
  end
end
