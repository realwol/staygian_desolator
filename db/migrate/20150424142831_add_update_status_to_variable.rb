class AddUpdateStatusToVariable < ActiveRecord::Migration
  def change
  	add_column :variables, :update_status, :boolean, default:true
  	add_column :variables, :translate_status, :boolean, default:false
  end
end
