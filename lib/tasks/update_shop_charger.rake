namespace :update_shop_charger do
  desc 'update shop charger'
  task run: :environment do
    Vendor.all.each do |vendor|
      puts vendor.id
      shop_id = vendor.shop_id
      brand_id = vendor.brand_id
      vendor_product_count_array = Product.find_by_sql("select user_id, count(user_id) as user_count from products
                                   where (shop_id = #{shop_id} and brand_id = #{brand_id} and on_sale = 1 and auto_flag != 13 and update_status = 1 and shield_type = 0) or
                                   (shop_id = #{shop_id} and brand_id = #{brand_id} and on_sale = 0 and shield_type = 0) or
                                   (shop_id = #{shop_id} and brand_id = #{brand_id} and auto_flag = 14)
                                   group by user_id
                                   order by user_count ")
      if vendor_product_count_array.present?
        charger_info = vendor_product_count_array.last
        user_id = charger_info.user_id
        user_count = charger_info.user_count
        user_count_sum = vendor_product_count_array.map(&:user_count).reduce(:+)
        vendor.update_attributes(user_id: user_id, products_percent: "#{user_count}/#{user_count_sum}")
      else
        vendor.update_attributes(user_id: nil, products_percent: "0/0")
      end
    end
  end
end
