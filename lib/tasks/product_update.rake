namespace :product_update do
  desc 'update product inventory and check on sale'
  task :check => :environment do
    product = get_product
    if product.present?
      start product
    end
  end
end

def start product
  return if product.origin_address.nil?
  agent = UserAgents.rand()
  html = Nokogiri::HTML(open(product.origin_address, 'User-Agent' => agent, :allow_redirections => :all ))

  if check_on_sale product, html
    update_stock product, html
  else
    update_stock product
  end

end

def check_on_sale product, html
  text_field = html.css('div.tb-meta strong.sold-out-tit')
  if text_field.present? && text_field.text == '此商品已下架'
    product.variables.update_all(stock: 0)
    puts 'off sale'
    return false
  else
    puts 'still on sale'
    return true
  end
end

def update_stock product, html=nil
  return if html.nil?

  js = html.css('script').to_s
  update_variable_array = []
  product.variables.each do |variable|
    update_variable_hash = {}
    sku_number = variable.variable_id
    s = js.index(sku_number)
    if s.nil?
      sku_number_array = sku_number.split(';')
      if sku_number_array.count > 1 
        sku_number = sku_number_array.rotate.join(';')
      else
        sku_number = ';' + sku_number_array.first
      end
      s = js.index(sku_number)
    end
    ss = js[s..-1].index('stock')
    ee = js[s..-1].index('}')
    stock = js[s..-1][ss+7..ee-1].to_i

    update_variable_hash[:stock] = stock
    variable.update_attributes(stock: stock)
  end
end

def get_product
  # Product.second
  Product.onsale.first.try(:origin_address)
end
