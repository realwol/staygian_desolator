class AddAutoUpdateFlagToTmallLink < ActiveRecord::Migration
  def change
    add_column :tmall_links, :auto_update, :text
  end
end
