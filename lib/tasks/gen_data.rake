namespace :gen_data do
  desc 'gen sku1 for which do not have'
  task gen_sku1: :environment do
    Product.where(sku1: nil).each do |p|
      size = rand(5..8)
      sku1 = (('a'..'z').to_a + (1..9).to_a).shuffle.sample(size).join
      p.update_attributes(sku1: sku1)
      puts p.id
    end
  end

  desc 'gen product id for merchant sku relation'
  task gen_product_id_for_merchant_sku_relation: :environment do
    MerchantSkuRelation.where(product_id: nil).where("id > 17731830").find_each do |r|
      puts r.id
      r_sku = r.sku
      if r_sku.present?
        index = r_sku.index('-')
        if index.present?
          sku_part = r_sku[0..index-1]
        else
          sku_part = r_sku
        end
        product = Product.select(:id).where(sku: sku_part).first
        product = Product.select(:id).where(sku1: sku_part).first unless product.present?
        r.update_column(product_id: product.id) if product.present?
      end
    end
  end

  desc 'gen unformatting sku info'
  task gen_unformatting_product: :environment do
    last_letter_array = ('A'..'Z').to_a
    count = 0
    a = Time.now
    MerchantSkuRelation.where(product_id: nil).order("id desc").limit(100000).each do |r|
      count = count + 1
      r_sku = r.sku
      if r_sku.present?
        if last_letter_array.include? r_sku.last
          sku_part = r_sku[0..-2]
        else
          sku_part = r_sku
        end
        product = Product.select(:id).where(sku1: sku_part).first
        product = Product.select(:id).where(sku: sku_part).first unless product.present?
        r.update_attributes(product_id: product.id) if product.present?
      end

      if Time.now - a > 60
        puts r.id, count
        count, a = 0, Time.now
      end
    end
  end

  desc 'gen new sku'
  task :gen_new_sku_to_product => :environment do
    Product.where(sku1:nil).find_each do |p|
      unless p.sku1.present?
        size = rand(5..8)
        sku1 = (('a'..'z').to_a + (1..9).to_a).shuffle.sample(size).join
        p.update_attributes(sku1: sku1)
        # p.update_attributes(sku1: sku1) unless Product.where(sku1: sku1).first.present?
        puts p.id
      end
    end
  end

  desc 'gen new sku in product base info'
  task :gen_new_sku_to_product_base_info => :environment do
    ProductBasicInfo.find_each do |info|
      product = Product.find(info.product_id)
      sku1 = info.sku.gsub(product.sku, product.sku1)
      info.update_attributes(sku1: sku1)
      puts info.id
    end
  end

  desc 're gen new sku in product base info'
  task re_gen_product_base_info: :environment do
    ProductBasicInfo.where("id > 846984").each do |info|
      if info.sku.present? && info.sku.try(:size) == 36 && info.sku.try(:size) != info.sku1.try(:size)
        puts info.id
        if info.variable.present?
          sku1 = gen_sku info.variable, info.product.sku1
          info.update_attributes(sku1: sku1)
        end
      end
    end
  end

def gen_sku variable, origin_sku
    if variable.color.present? && variable.size.present?
      v_color = VariableTranslateHistory.select(:en).where(word: variable.color, variable_from:'color').first
      v_size = VariableTranslateHistory.select(:en).where(word: variable.size, variable_from:'size').first
      sku = "#{origin_sku}-#{v_color.try(:en)}#{v_size.try(:en)}"[0..35].lstrip
    elsif variable.color.present?
      v_color = VariableTranslateHistory.select(:en).where(word: variable.color, variable_from:'color').first
      sku = "#{origin_sku}-#{v_color.try(:en)}"[0..35].lstrip
    elsif variable.size.present?
      v_size = VariableTranslateHistory.select(:en).where(word: variable.size, variable_from:'size').first
      sku = "#{origin_sku}-#{v_size.try(:en)}"[0..35].lstrip
    end
    sku
end
  desc 'merge redundancy shop'
  task merge: :environment do
    Shop.where(status: 1).each do |shop|
      dup_shops = Shop.where(name: shop.name)
      if dup_shops.size > 1
        dup_shops.each do |dup|

        end
      end
    end

    shop_names.each do |name|
      shops = Shop.where(name: name)
      shop_brands_array = shops.map { |shop| shop.brands.pluck(:id) }
      shop_brands_array.each do |relation|

      end
    end

    def re id1, *id2
      Product.where(shop_id: id2).update_all(shop_id: id1)
      Vendor.where(shop_id: id2).try(:destroy_all)
      BrandShopRelation.where(shop_id: id2).try(:destroy_all)
      Shop.where(id: id2).try(:destroy_all)
    end

    def sb *id
      sid_array = []
      id.each do |sid|
        sid_array << Shop.find(sid).brands.pluck(:id).join(' ')
      end
      puts sid_array
      "      re #{id.join(',')}          "
    end

    def sb *id
      sid_array = []
      id.each do |sid|
        sid_array << Shop.find(sid).brands.pluck(:id).join(' ')
      end

      a = sid_array.size
      b = 1
      flag = true
      while a > 0
        puts sid_array[b-1]
        if sid_array[b] != sid_array[b-1]
          flag = false 
          break
        end
        a = a - 1
      end
      puts sid_array.size, flag
      if flag
        id1 = id.first
        id2 = id[1..-1]
        Product.where(shop_id: id2).update_all(shop_id: id1)
        Vendor.where(shop_id: id2).try(:destroy_all)
        BrandShopRelation.where(shop_id: id2).try(:destroy_all)
        Shop.where(id: id2).try(:destroy_all)
      end
    end

  end
end
