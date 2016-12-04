namespace :gen_data do
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
