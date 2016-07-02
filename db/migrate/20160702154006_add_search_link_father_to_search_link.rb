class AddSearchLinkFatherToSearchLink < ActiveRecord::Migration
  def change
    add_column :search_links, :father_id, :integer
  end
end
