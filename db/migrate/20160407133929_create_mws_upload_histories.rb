class CreateMwsUploadHistories < ActiveRecord::Migration
  def change
    create_table :mws_upload_histories do |t|
      t.integer :user_id
      t.text :xml_body

      t.timestamps null: false
    end
  end
end
