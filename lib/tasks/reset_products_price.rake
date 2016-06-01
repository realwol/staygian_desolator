namespace :reset_products_price do
  desc 'set all product_basic_info for on product'
  task :reset_product => :environment do
    [32720,36344,37478,37849,40428,42064,43120,43253,43328,43799,43807,43812].each do |id|
      @product_basic_infos = ProductBasicInfo.where(product_id: id)
      puts id
      product = Product.find(id)
        %w(america canada british germany spain italy france).each do |language|
          cash_rate = CashRate.last.try(language.to_sym).to_f
          shipment_cost = product.get_shipment_cost(language)
          profit_rate = product.get_profit_rate language
          price = (1 + ((shipment_cost + product.try(:price).try(:to_f)) * profit_rate / cash_rate).to_i).to_i
          # info.public_send("#{language}=", price) if price.present?
          @product_basic_infos.update_all( "#{language}".to_sym => price)
          puts price
        end
      @product_basic_infos.update_all(spain_price_change: true, italy_price_change:true, france_price_change:true, america_price_change: true, canada_price_change: true, british_price_change:true, germany_price_change:true)
    end
  end

  desc 'reset products price'
  task :reset => :environment do
    
    # @products = Product.where("id in ? ", "(57,3343,4494,13027,13093,13096)")
    # @product_basic_infos = ProductBasicInfo.where("product_id in ? ", "(57,3343,4494,13027,13093,13096)")
    # @product_basic_infos = ProductBasicInfo.where("product_id in (?) ", [57,3343,4494,13027,13093,13096,14600,14601,15039,15965,18113,22100,32720,36344,37478,37849,40428,42064,43120,43253,43328,43799,43807,43812])
    @product_basic_infos = ProductBasicInfo.where("product_id in (?) ", [14601,15039,15965,18113,22100,32720,36344,37478,37849,40428,42064,43120,43253,43328,43799,43807,43812])
    @product_basic_infos.each do |info|
      # puts info.product_id
      product = Product.find(info.product_id)
      next unless product.present?
      %w(america canada british germany spain italy france).each do |language|
        cash_rate = CashRate.last.try(language.to_sym).to_f
        shipment_cost = product.get_shipment_cost(language)
        profit_rate = product.get_profit_rate language
        price = (1 + ((shipment_cost + product.try(:price).try(:to_f)) * profit_rate / cash_rate).to_i).to_i
        info.public_send("#{language}=", price) if price.present?
      end
      info.america_price_change = true
      info.canada_price_change = true
      info.british_price_change = true
      info.germany_price_change = true
      info.spain_price_change = true
      info.italy_price_change = true
      info.france_price_change = true

      info.save
    end
  end
end