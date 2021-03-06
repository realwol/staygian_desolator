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
  # tmall_link = TmallLink.find(119)
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

  # Create Product
  @product = Product.new(translate_status:false, update_status:false, on_sale:true, user_id: tmall_link.user_id)
  @product.origin_address = tmall_link.address
  @product.title = html.css('div.tb-detail-hd h1').text.strip

  grasp_filter_words = tmall_link.shop.grasp_filter
  filter_flag = false
  grasp_filter_words.each do |word|
    filter_flag = true unless @product.title.index(word).nil?
  end
  return if filter_flag
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
