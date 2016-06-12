class AddSearchLinkRelationToTmallLinkAndProduct < ActiveRecord::Migration
  def change
    add_column :products, :search_link_id, :string
    add_column :tmall_links, :search_link_id, :string
    add_column :search_links, :first_link_status, :boolean, default: 1
  end
end
