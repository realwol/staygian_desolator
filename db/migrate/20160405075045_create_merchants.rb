class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :shop_name
      t.string :merchant_plantform_name
      t.string :merchant_account
      t.integer :admin_id
      t.integer :user_id
      t.string :merchant_country_name
      t.string :merchant_type
      t.string :merchant_aws_access_key_id
      t.string :merchant_secrect_key
      t.string :merchant_seller_id
      t.string :merchant_marketplace_id
      t.string :merchant_api_address

      t.timestamps null: false
    end
  end
end
