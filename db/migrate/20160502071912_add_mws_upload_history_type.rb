class AddMwsUploadHistoryType < ActiveRecord::Migration
  def change
    add_column :mws_upload_histories, :upload_type, :string, after: :xml_body
  end
end
