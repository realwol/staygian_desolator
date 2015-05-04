namespace :grasp do
	desc "Grasp from tmall"
	task :start => :environment do
    sleep (0..9).to_a.sample
    start
    sleep 20
    sleep (0..9).to_a.sample
    start
	end
end

def start
	tmall_link = ungrasp_tmall_link
	# tmall_links.each do |link|
		grasp tmall_link.address
		tmall_link.update_attributes(status:true)
	# end
end

def grasp link
    # if Product.where(origin_address: link).count > 0
    #   flash[:alert] = '不能重复抓取了哟！'
    #   render 'grasp_product'
    # end
  agent = UserAgents.rand()
  html = Nokogiri::HTML(open(link, 'User-Agent' => agent, :allow_redirections => :all ))

  # Create Product
  @product = Product.new(translate_status:false, update_status:false, on_sale:true)
  @product.origin_address = link
  @product.title = html.css('div.tb-detail-hd').text.strip
  @product.brand = html.css('li#J_attrBrandName').text.slice(4..-1)

  html.css('ul#J_AttrUL li').each do |li|
    if li.text.include?('货号:')
      @product_number = li.text.slice(4..-1)
    end
  end

  @product.product_number = @product_number

  @images = []
  html.css('ul#J_UlThumb li a img').each do |img|
    @images << img["src"][0..img["src"].index('.jpg')+3]
  end

  @details = []
  @details_string = html.css('div#attributes div#J_AttrList ul#J_AttrUL li')

  flag1 = flag2 = flag3 = flag4 = flag5 = flag6 = true  

  @details_string.each do |d|
    @details << d.text+"<br/>\n"

    if flag1 && d.text.index('帮面材质') 
      @product.outer_material_type = d.text.gsub!('帮面材质:', '').lstrip[1..-1]
      flag1 = false
    end

    if flag2 && d.text.index('内里材质') 
      @product.inner_material_type = d.text.gsub!('内里材质:', '').lstrip[1..-1]
      flag2 = false
    end

    if flag3 && d.text.index('鞋底材质') 
      @product.sole_material = d.text.gsub!('鞋底材质:', '').lstrip[1..-1]
      flag3 = false
    end

    if flag4 && d.text.index('跟底款式') 
      @product.heel_type = d.text.gsub!('跟底款式:', '').lstrip[1..-1]
      flag4 = false
    end

    if flag5 && d.text.index('闭合方式') 
      @product.closure_type = d.text.gsub!('闭合方式:', '').lstrip[1..-1]
      flag5 = false
    end

    if flag6 && d.text.index('制造商') 
      @product.producer = d.text.gsub!('制造商:', '').lstrip[1..-1]
      flag6 = false
    end
  end

  @product.details = @details.join

  @images.each_with_index do |img, index|
  	@product["images#{index+1}".to_sym] = img
  end
  @product.save

  # Create variables
  @variable_images = @images.dup
  html.css('div.tb-sku dl.tb-prop.tm-sale-prop.tm-clear.tm-img-prop li').each do |img|
    image_url = img.children[1].attributes["style"].value
    start_index = image_url.index('http://')
    end_index   = image_url.index('.jpg')
    url = image_url[start_index..(end_index+3)]
    @variable_images << url unless @variable_images.include?(url)
  end

  variable_image_hash = {}
  @variable_images.each_with_index do |img,index|
  	variable_image_hash["image_url#{index+1}".to_sym] = img
  end

  @sizes = []
  @colors = []
  @colors_value = []
  @sizes_value = []
  @var_title = []

  variables = html.css('div.tb-key div.tb-skin div.tb-sku dl dd ul')
  variables.each do |variable|
    if variable.attributes["data-property"]
      @var_title << variable.attributes["data-property"].value
    end
  end

  html.css('div.tb-key div.tb-skin div.tb-sku dl dd ul.tm-clear.J_TSaleProp.tb-img li').each do |li|
    @colors << li.attributes["title"].value
    @colors_value << li.attributes["data-value"].value
  end

  html.css('div.tb-key div.tb-skin div.tb-sku dl dd ul.tm-clear.J_TSaleProp li').each do |li|
    @sizes << li.children.children.text.strip
    @sizes_value << li.attributes["data-value"].value
  end

  @sizes = @sizes - @colors
  @stock = []
  variable_array = []
  variable_hash = {}
  js = html.css('script').to_s
  start = js.index('skuMap').to_i
  if start
    js = js[start..-1]
    stock_count = 0
    @colors.each_with_index do |color,c_index|
      @sizes.each_with_index do |size,s_index|
        start = js.index("#{@sizes_value[s_index]};#{@colors_value[c_index]}")
        startt = js[start..-1].index('stock')
        endd = js[start..-1].index('}')
        @stock << js[start..-1][startt..endd].match(/\d+/)[0]
        variable_hash[:color] = color
        variable_hash[:size] = size
        variable_hash[:stock] = @stock[stock_count]
        stock_count = stock_count + 1
        variable_hash[:product_id] = @product.id
  		  @variable_images.each_with_index do |img,index|
  			  variable_hash["image_url#{index+1}".to_sym] = img
  		  end

        variable_array << variable_hash.dup
      end
    end
    Variable.create(variable_array)
  end

end

def ungrasp_tmall_link
	TmallLink.where(status:false).first
end
