namespace :grasp do
	desc "Grasp from tmall"
	task :start => :environment do
    start
	end
end

def start
	tmall_link = ungrasp_tmall_link
	# tmall_links.each do |link|
  unless tmall_link.blank?
		tmall_link.update_attributes(status:true)
    Product.uncached do
      if Product.where(product_link_id: tmall_link.product_link_id).first
        return
      end
    end
    grasp tmall_link
  else
    puts 'sleeping'
	end
end

def grasp tmall_link
    # if Product.where(origin_address: tmall_link).count > 0
    #   flash[:alert] = '不能重复抓取了哟！'
    #   render 'grasp_product'
    # end
  agent = UserAgents.rand()
  html = Nokogiri::HTML(open(tmall_link.address, 'User-Agent' => agent, :allow_redirections => :all ))

  # Create Product
  @product = Product.new(translate_status:false, update_status:false, on_sale:true)
  @product.origin_address = tmall_link.address
  @product.title = html.css('div.tb-detail-hd h1').text.strip
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
    @main_images << ('http:' + img["src"][0..img["src"].index('.jpg')+3])
  end

  @details = []
  @details_string = html.css('div#attributes div#J_AttrList ul#J_AttrUL li')

  flag1 = flag2 = flag3 = flag4 = flag5 = flag6 = true

  @details_string.each do |d|
    # Todo
    d_text = d.text.gsub(' ', '/').gsub(':/', ': ')
    @details << d_text + "<br/>\n"

    if flag1 && d.text.index('帮面材质') 
      outer_material_type = d.text.gsub!('帮面材质:', '').lstrip[1..-1]
      @product.outer_material_type = outer_material_type
      attribute_value = ShoesAttributesValue.where(name:outer_material_type).last
      if attribute_value
        @product.outer_material_type_england = attribute_value.england
        @product.outer_material_type_germany = attribute_value.germany
        @product.outer_material_type_france = attribute_value.france
        @product.outer_material_type_spain = attribute_value.spain
        @product.outer_material_type_italy = attribute_value.italy
      end
      flag1 = false
    end

    if flag2 && d.text.index('内里材质') 
      inner_material_type = d.text.gsub!('内里材质:', '').lstrip[1..-1]
      @product.inner_material_type = inner_material_type
      attribute_value = ShoesAttributesValue.where(name:inner_material_type).last
      if attribute_value
        @product.inner_material_type_england = attribute_value.england
        @product.inner_material_type_germany = attribute_value.germany
        @product.inner_material_type_france = attribute_value.france
        @product.inner_material_type_spain = attribute_value.spain
        @product.inner_material_type_italy = attribute_value.italy
      end
      flag2 = false
    end

    if flag3 && d.text.index('鞋底材质') 
      sole_material = d.text.gsub!('鞋底材质:', '').lstrip[1..-1]
      @product.sole_material = sole_material
      attribute_value = ShoesAttributesValue.where(name:sole_material).last
      if attribute_value
        @product.sole_material_england = attribute_value.england
        @product.sole_material_germany = attribute_value.germany
        @product.sole_material_france = attribute_value.france
        @product.sole_material_spain = attribute_value.spain
        @product.sole_material_italy = attribute_value.italy
      end
      flag3 = false
    end

    if flag4 && d.text.index('跟底款式') 
      heel_type = d.text.gsub!('跟底款式:', '').lstrip[1..-1]
      @product.heel_type = heel_type
      attribute_value = ShoesAttributesValue.where(name:heel_type).last
      if attribute_value
        @product.heel_type_england = attribute_value.england
        @product.heel_type_germany = attribute_value.germany
        @product.heel_type_france = attribute_value.france
        @product.heel_type_spain = attribute_value.spain
        @product.heel_type_italy = attribute_value.italy
      end
      flag4 = false
    end

    if flag5 && d.text.index('闭合方式') 
      closure_type = d.text.gsub!('闭合方式:', '').lstrip[1..-1]
      @product.closure_type = closure_type
      attribute_value = ShoesAttributesValue.where(name:closure_type).last
      if attribute_value
        @product.closure_type_england = attribute_value.england
        @product.closure_type_germany = attribute_value.germany
        @product.closure_type_france = attribute_value.france
        @product.closure_type_spain = attribute_value.spain
        @product.closure_type_italy = attribute_value.italy
      end
      flag5 = false
    end
  end

  @product.producer = html.css('div#shopExtra strong').text

  @product.details = @details.join

  # Create variables
  @product_images = []
  @variable_images = []
  # @product_images = @images.dup
  html.css('div.tb-sku dl.tb-prop.tm-sale-prop.tm-clear.tm-img-prop li').each do |img|
    image_url = img.children[1].attributes["style"].try(:value)
    if image_url
      start_index = image_url.index('//') + 2
      end_index   = image_url.index('.jpg') + 3
      url = 'http://' + image_url[start_index..end_index]
      @variable_images << url unless @variable_images.include?(url)
    end
  end

  test_start = Time.now

  @variable_images.each_with_index do |image, index|
    v_image = QiniuUploadHelper::QiNiu.upload(image, '')
    @variable_images[index] = v_image
    @product_images[index] = v_image
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
  js = html.css('script').to_s
  start = js.index('skuMap').to_i
  if start
    js = js[start..-1]
    stock_count = 0
    @colors.each_with_index do |color,c_index|
      @sizes.each_with_index do |size,s_index|
        variable_id = "#{@sizes_value[s_index]};#{@colors_value[c_index]}"
        start = js.index(variable_id)
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
    Variable.create(variable_array)
  end

end

def ungrasp_tmall_link
	TmallLink.where(status:false).first
end
