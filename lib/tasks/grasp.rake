require 'openssl'

namespace :grasp do
	desc "Grasp from tmall"
	task :start => :environment do
    a = Time.now
    while (Time.now - a) < (60 * 10 - 5)
      if start
        # sleep rand(1..5)
      end
    end
	end
end

def start
	tmall_link = ungrasp_tmall_link
    if tmall_link.present?
      # if TmallLink.where(product_link_id: tmall_link.product_link_id).count > 1
      if Product.find_by(product_link_id: tmall_link.product_link_id).present?
        tmall_link.update_attributes(status:true)
        puts 'duplicate product'
        return false
      else
        a = Time.now
        tmall_link.update_attributes(status:true)
        grasp_product tmall_link
        puts Time.now - a
      end
    else
      puts "sleeping in #{Time.now}"
    end
end

def grasp_product tmall_link
  puts tmall_link.id
  agent = UserAgents.rand()
  html = Nokogiri::HTML(open(tmall_link.address, 'User-Agent' => agent, :allow_redirections => :all ))

  # Create Product
  @product = Product.new(translate_status:false, update_status:false, on_sale:true, user_id: tmall_link.user_id)
  @product.origin_address = tmall_link.address
  @product.title = html.css('div.tb-detail-hd h1').text.strip
  @product.search_link_id = tmall_link.search_link_id
  
  if tmall_link.shop.present?
    grasp_filter_words = tmall_link.shop.grasp_filter
    filter_flag = false
    grasp_filter_words.each do |word|
      filter_flag = true unless @product.title.index(word).nil?
    end
    return if filter_flag
  end
  js = html.css('script').to_s
  stock_start = js.index('quantity":')
  stock_end = js[stock_start..-1].index(',')
  stock = js[stock_start+10..stock_end+stock_start-1]
  @product.stock = stock
  # @product.brand = html.css('li#J_attrBrandName').text.slice(4..-1)
  @product.shop_id = tmall_link.shop_id
  @product.product_link_id = tmall_link.product_link_id

  html.css('ul#J_AttrUL li').each do |li|
    if (li.text.include?('货号:') || li.text.include?('款号:'))
      @product_number = li.text.slice(4..-1)
    end
  end

  @product.product_number = @product_number

  @main_images = []
  html.css('ul#J_UlThumb li a img').each do |img|
    @main_images << ('https:' + img["src"][0..img["src"].index('.jpg')+3])
  end

  @details = []
  @details_string = html.css('div#attributes div#J_AttrList ul#J_AttrUL li')

  flag1 = flag2 = flag3 = flag4 = flag5 = flag6 = true
  @details_string.each do |d|
    # Todo
    d_text = d.text.gsub(' ', '/').gsub(':/', ': ')
    @details << d_text + "<br/>\n"
  end

  d = html.css('table.tm-tableAttr tbody tr')
  @d_details = []
  d.each do |dd|
    @d_details << dd.css('td').text + ":" + dd.css('th').text
  end

  @d_details.each do |d|
    # Todo
    @details << d + "<br/>\n"
  end


  @product.producer = html.css('div#shopExtra strong').text

  unless @details.present?
    aa = js.index('newProGroup')
    bb = js.index(',"progressiveSupport"')
    bb = js.length if bb.nil?
    a = Iconv.iconv("utf-8","gbk", js[aa..bb]).join
    b = a.split('groupName')
    b.pop
    b.each do |bb|
      if bb.index('name').present?
        bb_start = bb.index('name') + 4
        c = bb[bb_start..-1]
        c.split('name').each do |cc|
          ccc = cc.split('value')
          key = ccc[0][3..-4]
          value = ccc[1][3..-6]
          @details << "#{key}:#{value}<br/>\n"
        end
      end
    end
  end

  details_after_filter = []
  filter_word_list = ProductDetailForbiddenList.all.map(&:word).uniq
  @details.each do |detail|
    if detail.index(':').nil?
      end_count = detail.length
    else
      end_count = detail.index(':') - 1
    end
    details_after_filter << detail unless filter_word_list.index(detail[0..end_count])
  end

  b_string = @details.join('')
  bs = b_string.index("品牌").to_i
  be = b_string[bs..-1].index("<br/>").to_i
  brand_name = b_string[bs+4..be+bs-1].try(:strip)
  related_brand = ''
  if brand_name.present?
    related_brand = Brand.find_by(name: brand_name)
    unless related_brand.present?
     related_brand = Brand.create(name: brand_name, status: 1)
    end
    # create connections from shop to brand
    binding_shop_with_brand @product.shop_id, related_brand.id
  end

  @product.brand_id = Brand.find_by(name: brand_name).try(:id)


  @product.details = details_after_filter.join

  # Create variables
  @product_images = []
  @variable_images = []
  html.css('div.tb-sku dl.tb-prop.tm-sale-prop.tm-clear.tm-img-prop li').each do |img|
    image_url = img.children[1].attributes["style"].try(:value)
    if image_url
      start_index = image_url.index('//') + 2
      end_index   = image_url.index('.jpg') + 3
      url = 'http://' + image_url[start_index..end_index]
      @variable_images << url unless @variable_images.include?(url)
    end
  end

  # @variable_images = @variable_images[0..8]

  test_start = Time.now

  @variable_images.each_with_index do |image, index|
    v_image = QiniuUploadHelper::QiNiu.upload(image, '')
    @variable_images[index] = v_image
    @product_images << v_image
  end

  # Upload image and replace the link
  @main_images.each_with_index do |image,index|
    upload_image = QiniuUploadHelper::QiNiu.upload(image,'')
    @main_images[index] = upload_image
    @product_images << upload_image
  end

  @product_images.each_with_index do |img, index|
    @product["images#{index+1}".to_sym] = img
  end

  if related_brand.status != '0'
    @product.shield_type = tmall_link.product_status if tmall_link.product_status.present?
    product_shop_id = @product.shop_id
    brand_shop_relation = BrandShopRelation.find_by(shop_id: product_shop_id, brand_id: related_brand.id)
    if brand_shop_relation.present?
      if brand_shop_relation.status == '1'
        @product.shield_type = 0
      elsif brand_shop_relation.status == '5'
        @product.shield_type = 5
      elsif brand_shop_relation.status == '2'
        tmall_link.destroy
        return false
      end
    end
  else
    @product.shield_type = 1
  end

  # remove products and tmall link if shop forbidden before save
  unless @product.shop.status
    tmall_link.destroy
    return false
  end
  @product.save
  @product.reload

  # product_brand = @product.brand
  # product_shop = @product.shop
  # brand_shop_relation = BrandShopRelation.find_by(shop_id: product_shop.id, brand_id: product_brand.id)
  # if brand_shop_relation.present?
  #   @product.update_attributes(shield_type: 5) if brand_shop_relation.status == '5'
  # end

  @sizes = []
  @colors = []
  @colors_value = []
  @sizes_value = []
  @var_title = []

  variables = html.css('div.tb-key div.tb-skin div.tb-sku dl dd ul')
  variables.each do |variable|
    if variable.attributes["data-property"]
      @var_title << variable.attributes["data-property"].try(:value)
    end
  end

  html.css('div.tb-key div.tb-skin div.tb-sku dl dd ul.tm-clear.J_TSaleProp.tb-img li').each do |li|
    @colors << li.attributes["title"].try(:value)
    @colors_value << li.attributes["data-value"].try(:value)
  end

  html.css('div.tb-key div.tb-skin div.tb-sku dl dd ul.tm-clear.J_TSaleProp li').each do |li|
    unless li.attributes["data-value"].try(:value).index('-1')
      @sizes << li.children.children.text.strip
      @sizes_value << li.attributes["data-value"].try(:value)
    end
  end

  @sizes = @sizes - @colors
  @sizes_value = @sizes_value - @colors_value

  variable_array = []
  variable_hash = {}
  @stock = []
  start = js.index('skuMap').to_i
  if start
    js = js[start..-1]
    stock_count = 0
    if @colors.present? && @sizes.present?
      @colors.each_with_index do |color,c_index|
        @sizes.each_with_index do |size,s_index|
          variable_id = "#{@sizes_value[s_index]};#{@colors_value[c_index]}"
          variable_id_backup = "#{@colors_value[c_index]};#{@sizes_value[s_index]}"
          start = js.index(variable_id)
          if start.nil?
            start = js.index(variable_id_backup)
            variable_id = variable_id_backup
          end
          if (start && @stock[stock_count] != 0)
            startt = js[start..-1].index('stock')
            endd = js[start..-1].index('}')
            @stock << js[start..-1][startt..endd].match(/\d+/)[0]
            variable_hash[:variable_id] = variable_id
            variable_hash[:color] = color
            variable_hash[:size] = size
            variable_hash[:stock] = @stock[stock_count]
            stock_count = stock_count + 1
            variable_hash[:product_id] = @product.id
            variable_hash["image_url1"] = @variable_images[c_index]
      		  @main_images.each_with_index do |img,index|
      			  variable_hash["image_url#{index+2}".to_sym] = img
      		  end
            variable_array << variable_hash.dup
            variable_hash = {}
            # todo: check variable images
          end
        end
      end
    elsif @sizes.present?
        @sizes.each_with_index do |size,s_index|
          variable_id = "#{@sizes_value[s_index]};"
          variable_id_backup = ";#{@sizes_value[s_index]}"
          start = js.index(variable_id)
          start = js.index(variable_id_backup) if start.nil?
          if (start && @stock[stock_count] != 0)
            startt = js[start..-1].index('stock')
            endd = js[start..-1].index('}')
            @stock << js[start..-1][startt..endd].match(/\d+/)[0]
            variable_hash[:variable_id] = variable_id
            variable_hash[:size] = size
            variable_hash[:stock] = @stock[stock_count]
            stock_count = stock_count + 1
            variable_hash[:product_id] = @product.id
            @main_images.each_with_index do |img,index|
              variable_hash["image_url#{index+2}".to_sym] = img
            end
            variable_array << variable_hash.dup
            variable_hash = {}
            # todo: check variable images
          end
        end
    elsif @colors.present?
        @colors.each_with_index do |color,c_index|
          variable_id = ";#{@colors_value[c_index]}"
          variable_id_backup = "#{@colors_value[c_index]};"
          start = js.index(variable_id)
          start = js.index(variable_id_backup) if start.nil?
          if (start && @stock[stock_count] != 0)
            startt = js[start..-1].index('stock')
            endd = js[start..-1].index('}')
            @stock << js[start..-1][startt..endd].match(/\d+/)[0]
            variable_hash[:variable_id] = variable_id
            variable_hash[:color] = color
            variable_hash[:stock] = @stock[stock_count]
            stock_count = stock_count + 1
            variable_hash[:product_id] = @product.id
            variable_hash["image_url1"] = @variable_images[c_index]
            @main_images.each_with_index do |img,index|
              variable_hash["image_url#{index+2}".to_sym] = img
            end
            variable_array << variable_hash.dup
            variable_hash = {}
            # todo: check variable images
          end
        end
    else
    end
    Variable.create(variable_array)
  end
end

def binding_shop_with_brand shop_id, brand_id
  shop_brand_relation = BrandShopRelation.find_by(shop_id: shop_id, brand_id: brand_id)
  unless shop_brand_relation.present?
    BrandShopRelation.create(brand_id: brand_id, shop_id: shop_id, status: 5)
    Brand.find(brand_id).update_attributes(has_stand_by: true)
  end
end

def ungrasp_tmall_link
  last_grasp = TmallLink.where(status: true).order('updated_at').last
  if last_grasp.present?
    next_grasp = TmallLink.where('id > ? and user_id != ? and status = ?', last_grasp.id, last_grasp.user_id, false).first
    if next_grasp.present?
      return next_grasp
    end
  end
  TmallLink.where(status:false).first
end
