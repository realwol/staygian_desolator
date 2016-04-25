require 'openssl'

namespace :grasp do
	desc "Grasp from tmall"
	task :start => :environment do
    # 10.times do
      if start
        sleep rand(5..10)
      else
        puts 'duplicate product'
      end
    # end
	end
end

def start
	tmall_link = ungrasp_tmall_link
  # tmall_links.each do |link|
  # while tmall_link.present?
    # do not store the same product
    if tmall_link.present?
      if TmallLink.where(product_link_id: tmall_link.product_link_id).count > 1
        tmall_link.update_attributes(status:true)
        puts tmall_link.address
        return false
      else
        tmall_link.update_attributes(status:true)
        grasp_product tmall_link
        sleep rand(5..10)
      end
    else
      puts "sleeping in #{Time.now}"
    end
    # tmall_link = ungrasp_tmall_link
  # end
end

def grasp_product tmall_link

  agent = UserAgents.rand()
  html = Nokogiri::HTML(open(tmall_link.address, 'User-Agent' => agent, :allow_redirections => :all ))
  # url = URI.parse( tmall_link.address)
  # http = Net::HTTP.new( url.host, url.port )
  # http.use_ssl = true if url.port == 443
  # http.verify_mode = OpenSSL::SSL::VERIFY_NONE if url.port == 443
  # html = Nokogiri::HTML(open(http.to_s))

  
  # html = Nokogiri::HTML(open(tmall_link.address))

  # Create Product
  @product = Product.new(translate_status:false, update_status:false, on_sale:true, user_id: tmall_link.user_id)
  @product.origin_address = tmall_link.address
  @product.title = html.css('div.tb-detail-hd h1').text.strip
  
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
  @product.brand = html.css('li#J_attrBrandName').text.slice(4..-1)
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

  # @main_images = @main_images[0..8]

  @details = []
  @details_string = html.css('div#attributes div#J_AttrList ul#J_AttrUL li')

  flag1 = flag2 = flag3 = flag4 = flag5 = flag6 = true

  @details_string.each do |d|
    # Todo
    d_text = d.text.gsub(' ', '/').gsub(':/', ': ')
    @details << d_text + "<br/>\n"

    # if flag1 && d.text.index('帮面材质') 
    #   outer_material_type = d.text.gsub!('帮面材质', '').lstrip[1..-1]
    #   @product.outer_material_type = outer_material_type
    #   attribute_value = ShoesAttributesValue.where(name:outer_material_type).last
    #   if attribute_value
    #     @product.outer_material_type_england = attribute_value.england
    #     @product.outer_material_type_germany = attribute_value.germany
    #     @product.outer_material_type_france = attribute_value.france
    #     @product.outer_material_type_spain = attribute_value.spain
    #     @product.outer_material_type_italy = attribute_value.italy
    #   end
    #   flag1 = false
    # end

    # if flag2 && d.text.index('内里材质') 
    #   inner_material_type = d.text.gsub!('内里材质', '').lstrip[1..-1]
    #   @product.inner_material_type = inner_material_type
    #   attribute_value = ShoesAttributesValue.where(name:inner_material_type).last
    #   if attribute_value
    #     @product.inner_material_type_england = attribute_value.england
    #     @product.inner_material_type_germany = attribute_value.germany
    #     @product.inner_material_type_france = attribute_value.france
    #     @product.inner_material_type_spain = attribute_value.spain
    #     @product.inner_material_type_italy = attribute_value.italy
    #   end
    #   flag2 = false
    # end

    # if flag3 && d.text.index('鞋底材质') 
    #   sole_material = d.text.gsub!('鞋底材质:', '').lstrip[1..-1]
    #   @product.sole_material = sole_material
    #   attribute_value = ShoesAttributesValue.where(name:sole_material).last
    #   if attribute_value
    #     @product.sole_material_england = attribute_value.england
    #     @product.sole_material_germany = attribute_value.germany
    #     @product.sole_material_france = attribute_value.france
    #     @product.sole_material_spain = attribute_value.spain
    #     @product.sole_material_italy = attribute_value.italy
    #   end
    #   flag3 = false
    # end

    # if flag4 && d.text.index('跟底款式') 
    #   heel_type = d.text.gsub!('跟底款式', '').lstrip[1..-1]
    #   @product.heel_type = heel_type
    #   attribute_value = ShoesAttributesValue.where(name:heel_type).last
    #   if attribute_value
    #     @product.heel_type_england = attribute_value.england
    #     @product.heel_type_germany = attribute_value.germany
    #     @product.heel_type_france = attribute_value.france
    #     @product.heel_type_spain = attribute_value.spain
    #     @product.heel_type_italy = attribute_value.italy
    #   end
    #   flag4 = false
    # end

    # if flag5 && d.text.index('闭合方式') 
    #   closure_type = d.text.gsub!('闭合方式', '').lstrip[1..-1]
    #   @product.closure_type = closure_type
    #   attribute_value = ShoesAttributesValue.where(name:closure_type).last
    #   if attribute_value
    #     @product.closure_type_england = attribute_value.england
    #     @product.closure_type_germany = attribute_value.germany
    #     @product.closure_type_france = attribute_value.france
    #     @product.closure_type_spain = attribute_value.spain
    #     @product.closure_type_italy = attribute_value.italy
    #   end
    #   flag5 = false
    # end
  end

  d = html.css('table.tm-tableAttr tbody tr')
  @d_details = []
  d.each do |dd|
    @d_details << dd.css('td').text + ":" + dd.css('th').text
  end

  @d_details.each do |d|
    # Todo
    @details << d + "<br/>\n"

    # if flag1 && d.index('帮面材质') 
    #   outer_material_type = d.gsub!('帮面材质', '').lstrip[1..-1]
    #   @product.outer_material_type = outer_material_type
    #   attribute_value = ShoesAttributesValue.where(name:outer_material_type).last
    #   if attribute_value
    #     @product.outer_material_type_england = attribute_value.england
    #     @product.outer_material_type_germany = attribute_value.germany
    #     @product.outer_material_type_france = attribute_value.france
    #     @product.outer_material_type_spain = attribute_value.spain
    #     @product.outer_material_type_italy = attribute_value.italy
    #   end
    #   flag1 = false
    # end

    # if flag2 && d.index('内里材质') 
    #   inner_material_type = d.gsub!('内里材质:', '').lstrip[1..-1]
    #   @product.inner_material_type = inner_material_type
    #   attribute_value = ShoesAttributesValue.where(name:inner_material_type).last
    #   if attribute_value
    #     @product.inner_material_type_england = attribute_value.england
    #     @product.inner_material_type_germany = attribute_value.germany
    #     @product.inner_material_type_france = attribute_value.france
    #     @product.inner_material_type_spain = attribute_value.spain
    #     @product.inner_material_type_italy = attribute_value.italy
    #   end
    #   flag2 = false
    # end

    # if flag3 && d.index('鞋底材质') 
    #   sole_material = d.gsub!('鞋底材质', '').lstrip[1..-1]
    #   @product.sole_material = sole_material
    #   attribute_value = ShoesAttributesValue.where(name:sole_material).last
    #   if attribute_value
    #     @product.sole_material_england = attribute_value.england
    #     @product.sole_material_germany = attribute_value.germany
    #     @product.sole_material_france = attribute_value.france
    #     @product.sole_material_spain = attribute_value.spain
    #     @product.sole_material_italy = attribute_value.italy
    #   end
    #   flag3 = false
    # end

    # if flag4 && d.index('跟底款式') 
    #   heel_type = d.gsub!('跟底款式', '').lstrip[1..-1]
    #   @product.heel_type = heel_type
    #   attribute_value = ShoesAttributesValue.where(name:heel_type).last
    #   if attribute_value
    #     @product.heel_type_england = attribute_value.england
    #     @product.heel_type_germany = attribute_value.germany
    #     @product.heel_type_france = attribute_value.france
    #     @product.heel_type_spain = attribute_value.spain
    #     @product.heel_type_italy = attribute_value.italy
    #   end
    #   flag4 = false
    # end

    # if flag5 && d.index('闭合方式') 
    #   closure_type = d.gsub!('闭合方式', '').lstrip[1..-1]
    #   @product.closure_type = closure_type
    #   attribute_value = ShoesAttributesValue.where(name:closure_type).last
    #   if attribute_value
    #     @product.closure_type_england = attribute_value.england
    #     @product.closure_type_germany = attribute_value.germany
    #     @product.closure_type_france = attribute_value.france
    #     @product.closure_type_spain = attribute_value.spain
    #     @product.closure_type_italy = attribute_value.italy
    #   end
    #   flag5 = false
    # end
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


  puts "===========upload cost"
  puts Time.now - test_start

  @product_images.each_with_index do |img, index|
    @product["images#{index+1}".to_sym] = img
  end

  @product.save
  @product.reload

  # variable_image_hash = {}
  # @product_images.each_with_index do |img,index|
  # 	variable_image_hash["image_url#{index+1}".to_sym] = img
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

def ungrasp_tmall_link
  last_grasp = TmallLink.where(status: true).order('updated_at').last
  if last_grasp.present?
    next_grasp = TmallLink.where('id > ? and shop_id != ? and status = ?', last_grasp.id, last_grasp.shop_id, false).first
    if next_grasp.present?
      return next_grasp
    end
  end
  TmallLink.where(status:false).first
end
