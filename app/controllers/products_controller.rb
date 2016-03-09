class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :shield_product, :presale_product, :offsale_product, :temp_offsale_product, :onsale_product, :edited_product, :translate_preview]
  before_action :authenticate_user!

  def regrasp_product
    product = Product.find(params[:id])
    product.variables.destroy_all
    product.product_info_translations.destroy_all
    product_address = product.origin_address
    product_tmall_link = TmallLink.where(address: product_address).first
    if product_tmall_link.present?
      product_tmall_link.update_attributes(status: false)
    else
      product_link_start = product_address.index('id') + 3
      product_link_end = product_address[product_link_start..-1].index('&') - 1 + product_link_start
      product_link_id = product_address[product_link_start..product_link_end]

      TmallLink.create(address: product_address, status:false, user: current_user, shop_id: product.shop_id, product_link_id: product_link_id)
    end
    product.destroy
    render json:true
  end

  def search_shop
    if params[:search_word].present?
      @shops = Shop.where("name like '%#{params[:search_word]}%'").order('name')
    else
      @shops = Shop.all
    end
  end

  def create_product_forbidden_word
    @flag = true
    unless ProductDetailForbiddenList.where(word: params[:word]).first.present?
      ProductDetailForbiddenList.create(word: params[:word])
      @all_forbidden_words = ProductDetailForbiddenList.all
    else
      @flag = false
    end
  end

  def product_detail_forbidden
    @all_forbidden_words = ProductDetailForbiddenList.all
  end

  def create_product_grasp_filter
    @flag = true
    unless Reference.where(key1:'grasp_filter_words', value: params[:word]).first.present?
      Reference.create(value: params[:word], key1:'grasp_filter_words')
      @all_forbidden_words = Reference.where(key1:'grasp_filter_words').using_now
    else
      @flag = false
    end
  end

  def product_grasp_filter
    @all_forbidden_words = Reference.where(key1:'grasp_filter_words')
  end

  def remove_key_word
    # if params[:remove_type] == '1'
      ProductDetailForbiddenList.destroy(params[:id])
      # @all_forbidden_words = Reference.where(key1:'grasp_filter_words').using_now
    # else
    # end
    render json:true
  end

  def translate_preview
    @product_translation = @product.product_info_translations.last
  end

  def custome_upload_image
    uploaded_io = params[:upload_path]
    # uploaded_io = params[:upload_path][12..-1]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io)
    end

    # v_image = QiniuUploadHelper::QiNiu.upload(params[:upload_path],'')
    render json: v_image.to_json
  end

  def update_product_type
    Product.where({id: params[:products_id].split()}).update_all(product_type_id: params[:product][:product_type_id])
    redirect_to root_path
  end

  def change_product_type
    @products = Product.find(params[:product_id].split())
  end

  def update_attributes_div
    @product_type_attributes = ProductAttribute.where(product_type_id: params[:product_type_id])
    @product = Product.find(params[:product_id])
  end
                               
  def update_price
    product = Product.find(params["product_id"])
    price = params["price"]

    if product.update_attributes(price:price)
      product.variables.each do |v|
        v.update_attributes(price:price)
      end
      render json:0
    else
      render json:1
    end
  end

  def search
    @result = {}
    @result[:type] = product_type = params[:product_select_value]
    @result[:shop] = product_shop = params[:product_shop]
    @result[:brand] = product_brand = params[:product_brand]
    @result[:sku] = sku_value = params[:sku_value]
    @action_from = params[:action_from]

    @products = Product.all
    search_query = []
    unless product_type.empty?
      ids_string = "(#{product_type},"
      ProductType.find(product_type).all_children.map(&:id).each do |id|
        ids_string = ids_string + id.to_s + ','
      end
      ids_string = ids_string[0, ids_string.size-1] + ')'
      search_query << "product_type_id in #{ids_string}"
    end

    unless product_shop.empty?
      # shops = Shop.where(name: product_shop).map(&:id)
      # @products = shop.products if shop
      @products = Product.where(producer: product_shop)
    end

    unless product_brand.empty?
      search_query << "brand like '%#{product_brand}%'"
    end

    unless sku_value.empty?
      search_query << "sku like '%#{sku_value}%'"
    end

    case @action_from
    when 'index'
      @search_value = @products.updated.un_shield.onsale.where("#{search_query.join(' and ')}").order('id desc').page(params[:page]).per(15)
    when 'off_sale_products'
      @result_type = '下线产品'
      @search_value = @products.offsale.where("#{search_query.join(' and ')}").order('id desc').page(params[:page]).per(15)
    when 'presaled_products'
      @result_type = '预售产品'
      @search_value = @products.pre_saled.where("#{search_query.join(' and ')}").order('id desc').page(params[:page]).per(15)
    when 'shield_products'
      @result_type = '屏蔽产品'
      @search_value = @products.shield.where("#{search_query.join(' and ')}").order('id desc').page(params[:page]).per(15)
    when 'un_updated_page'
      @result_type = '未更新产品'
      @search_value = @products.un_updated.where("#{search_query.join(' and ')}").order('id desc').page(params[:page]).per(15)
    when 'temp_off_sale_products'
      @result_type = '临时下线产品'
      @search_value = @products.temp_offsale.where("#{search_query.join(' and ')}").order('id desc').page(params[:page]).per(15)
    end
  end

  def check_shop_id
    if Shop.shop_avaliable? params[:shop_id]
      render json: 1
    else
      render json: 0
    end
  end

  def export_page
    
  end

  def export_products
    puts '======================'
    puts 'I am in exporting now!'
    puts Time.now

    params[:export_type] = params[:product][:product_type_id]
    start_sku = params[:start_sku]
    choose_product_type = ProductType.find(params[:export_type].to_i)
    product_type_combo = [choose_product_type]
    product_type_combo << choose_product_type.all_children
    product_type_combo.flatten!

    if start_sku.blank?
      @products = current_user.valid_products.where(product_type: product_type_combo).order('id desc').limit(1000)
    else
      start_product = current_user.valid_products.where(sku:start_sku).last

      unless start_product
        redirect_to export_page_products_url, notice:'Sku错误'
        return
      end
      
      start_product_type = start_product.try(:product_type)
      unless start_product_type.present?
        redirect_to export_page_products_url, notice:'Sku对应产品无分类！'
        return
      end
      if (choose_product_type != start_product_type) && (choose_product_type.all_children.index(start_product_type).nil?)
      # unless start_product.try(:product_type) == params[:export_type].to_i
        redirect_to export_page_products_url, notice:'Sku与所选分类不匹配'
        return
      end
      # @products = current_user.valid_products.where(product_type: product_type_combo).where("first_updated_time > ? and on_sale = 1", start_product.first_updated_time).order('id desc').limit(1000)
      @products = current_user.valid_products.where("first_updated_time > ? and on_sale = 1", start_product.first_updated_time).order('id desc').where(product_type: product_type_combo).limit(1000)
    end
    cookies[:export_language] = params[:language]
    cookies[:export_type] = params[:export_type]
    request.format = 'xls'
    filename = "#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}_export_data.xls"
    puts '==========='
    puts @products.count
    respond_to do |f|
      f.xls {send_data @products.to_csv(params[:language], params[:max_number], col_sep: "\t"), filename: filename }
      # f.xls
    end
  end

  def onsale_product
    @product.update_attributes(on_sale:true, shield_type:0, update_status:true, translate_status: false)
    redirect_to root_path
  end

  def off_sale_products
    @action_from = params[:action]
    @products = selected_user.valid_products.offsale.page(params[:page])
  end

  def off_sale_all
    unless params[:all_offsale_products].blank?
      selected_user.valid_products.where(id:params[:all_offsale_products].split(' ')).update_all(shield_type:0, on_sale:false, update_status:true)
    end
    redirect_to root_path
  end

  def on_sale_all
    unless params[:all_onsale_products].blank?
      selected_user.valid_products.where(id:params[:all_onsale_products].split(' ')).update_all(shield_type:0, on_sale:true, update_status:true)
    end
    redirect_to root_path
  end

  def shield_all
    unless params[:all_shield_products].blank?
      selected_user.valid_products.where(id:params[:all_shield_products].split(' ')).update_all(shield_type:1, on_sale:true, update_status:true)
    end
    redirect_to root_path
  end

  def temp_off_sale_products
    @action_from = params[:action]
    @products = selected_user.valid_products.temp_offsale.page(params[:page])
  end

  def temp_off_sale_all
    unless params[:all_products].blank?
      selected_user.valid_products.where(id:params[:all_products].split(' ')).update_all(shield_type:3, on_sale:false, update_status:true)
    end
    redirect_to root_path
  end

  def offsale_product
    @product.update_attributes(on_sale:false, shield_type: 0, update_status:true)
    redirect_to off_sale_products_products_url
  end

  def temp_offsale_product
    @product.update_attributes(shield_type:3, on_sale:false)
    redirect_to temp_off_sale_products_products_url
  end

  def shield_products
    @action_from = params[:action]
    @products = selected_user.valid_products.shield.page(params[:page])
  end

  def shield_product
    @product.update_attributes(shield_type:'1', on_sale:false, update_status:true)
    redirect_to shield_products_products_path
  end

  def edited_product
    @product.update_attributes(shield_type:'4', on_sale:false, update_status:true, editing_backup: params[:editing_backup])
    redirect_to edited_products_products_path
  end

  def edited_products
    @action_from = params[:action]
    @products = selected_user.valid_products.edited.page(params[:page])
  end

  def presaled_products
    @action_from = params[:action]
    @products = selected_user.valid_products.pre_saled.page(params[:page])
  end

  def presale_product
    @product.update_attributes(shield_type:'2', presale_date: params[:presale_date], on_sale:false, update_status:true)
    redirect_to presaled_products_products_url
  end

  def wait_designer
    @products = selected_user.valid_products.edited.page(params[:page])
  end

  def un_updated_page
    @action_from = params[:action]
    @products = selected_user.valid_products.un_updated.page(params[:page])
  end

  def get_tmall_links 
    @shops = current_user.shops.page(params[:page])
  end

  def get_tmall_link_from_link
    # @shops = current_user.shops
    @shops = Shop.order('name')
  end

  # Move grasp tmall_links to a rake task and keep one shop in 60-80 sec
  def save_tmall_links
    if params[:direct_link].present?
      shop = Shop.create(name:params[:shop_name], user_id: current_user.id, status:true, shop_from: 'tmall', shop_id: params[:shop_id], search_word: params[:search_word], filter_word: params[:filter_word], manufacture: params[:manufacture])
      ShopLink.create( link:params[:direct_link], user: current_user, status: false, shop_id: shop.id, link_from: 'search')
    else
      unless Shop.shop_avaliable? params[:links]
        redirect_to root_path and return 
      end
      link = "http://list.tmall.com/search_shopitem.htm?user_id=" + params[:links]
      unless params[:shop_name].blank?
        shop = Shop.create(name:params[:shop_name], user_id: current_user.id, status:true, shop_from: 'tmall', shop_id: params[:links])
      end
      ShopLink.create(shop_id_string:params[:links], link:link, user: current_user, status: false, shop_id: shop.try(:id), link_from: 'shop')
    end
    redirect_to root_path
  end

  def index
    @action_from = params[:action]
    @products = selected_user.valid_products.updated.onsale.un_shield.order('first_updated_time desc').page(params[:page])
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @product_type_attributes = ProductAttribute.where(product_type_id: @product.product_type_id)
    @product_attributes_value = @product.product_customize_attributes_relations
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    respond_to do |format|
      if @product.save
        format.html { redirect_to root_path, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    if params[:product][:avatar].present?
      flag = [false, false, false]
      if params[:product][:avatar][1].present?
        params[:product][:avatar1] = params[:product][:avatar][1]
        flag[1] = true
      end
     if params[:product][:avatar][2].present?
        params[:product][:avatar2] = params[:product][:avatar][2]
        flag[2] = true
      end
     if params[:product][:avatar][0].present?
        params[:product][:avatar] = params[:product][:avatar][0]
        flag[0] = true
      end
    else
      params[:product][:avatar], params[:product][:avatar1], params[:product][:avatar2] = '', '', ''
    end

    # clear all products images before create
    @product.images1 = @product.images2 =@product.images3 = @product.images4 = @product.images5 = @product.images6 = @product.images7 = @product.images8 = @product.images9 = @product.images10 = nil
    @product.images11 = @product.images12 =@product.images13 = @product.images14 = @product.images15 = @product.images16 = @product.images17 = @product.images18 = @product.images19 = @product.images20 = nil
    @product.images21 = @product.images22 =@product.images23 = @product.images24 = @product.images25 = @product.images26 = @product.images27 = @product.images28 = @product.images29 = @product.images30 = nil

    respond_to do |format|
      @product.shield_type = 0
      @product.on_sale = true
      @product.update_status = true
      if @product.update(product_params)
        if @product.first_updated_time
          @product.update_attributes(update_status:true)
        else
          @product.update_attributes(update_status:true, first_updated_time: Time.now)
        end
        # @product.save_attributes

        @product_type_attributes = ProductAttribute.where(product_type_id: @product.product_type_id)
        customize_attributes_hash = {}
        customize_attributes_array = []
        @product_type_attributes.each_with_index do |attribute, index|
          product_attribute = @product.product_customize_attributes_relations.where(attribute_name: attribute.attribute_name).last
          if product_attribute.present?
            if attribute.is_locked
              attributes_translation_history_id = params["attribte_options"].values[index]
            else
              attributes_translation_history_id = AttributesTranslationHistory.where(attribute_name: params["attribte_options"].values[index]).first.try(:id)
            end
            product_attribute.update_attributes(attributes_translation_history_id: attributes_translation_history_id)
          else
            customize_attributes_hash[:product_type_id] = @product.product_type_id
            customize_attributes_hash[:product_id] = @product.id
            customize_attributes_hash[:attribute_name] = attribute.attribute_name
            if attribute.is_locked
              customize_attributes_hash[:attributes_translation_history_id] = params["attribte_options"].values[index]
            else
              customize_attributes_hash[:attributes_translation_history_id] = AttributesTranslationHistory.where(attribute_name: params["attribte_options"].values[index]).first.try(:id)
            end
            customize_attributes_array << customize_attributes_hash.dup
          end
        end

        ProductCustomizeAttributesRelation.create(customize_attributes_array) if customize_attributes_array.present?

        # Tobe cut
        if params[:cut_image_urls][2..-1]
          cut_image_urls = params[:cut_image_urls][2..-1].split('|')
          cut_image_urls.each do |url|
            puts 'old image cut'
            QiniuUploadHelper::QiNiu.update(url, @product.image_cut_position, @product.image_cut_x, @product.image_cut_y) if url.present?
            sleep 0.5
          end
        end

        avatar_urls = []
        if params[:product][:avatar].present?
          @product.avatar_img_url, @product.avatar_img_url1, @product.avatar_img_url2 = nil
          [@product.avatar.url, @product.avatar1.url, @product.avatar2.url].each_with_index do |img_url, index|
            if img_url.present?
              puts 'image upload'
              avatar_urls << QiniuUploadHelper::QiNiu.upload_from_client(Rails.root.join('public' "#{img_url}")) if flag[index]
              sleep 1 # keep the upload the right result
            end
          end
          @product.avatar_img_url = avatar_urls[0]
          @product.avatar_img_url1 = avatar_urls[1]
          @product.avatar_img_url2 = avatar_urls[2]
          @product.avatar = @product.avatar1 = @product.avatar2 = nil
        else
          @product.avatar_img_url, @product.avatar_img_url1, @product.avatar_img_url2 = nil
          @product.avatar = @product.avatar1 = @product.avatar2 = nil
        end
        @product.translate_status = false
        @product.save

        if params["variable"].present?
          Variable.update_product_variable(params["variable"], @product)
          params["variable"].each do |param_variable|
            variable_size = param_variable["size"]
            variable_color = param_variable["color"]

            if VariableTranslateHistory.where(word: variable_size, variable_from: 'size').count < 1
              VariableTranslateHistory.create(word: variable_size, variable_from: 'size', user: current_user)
            end

            if VariableTranslateHistory.where(word: variable_color, variable_from: 'color').count < 1
              VariableTranslateHistory.create(word: variable_color, variable_from: 'color', user: current_user)
            end
          end
        end
        TranslateToken.create(t_id:@product.id, t_type:'product', t_status: true, t_method:'update')
        format.html { redirect_to un_updated_page_products_url, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    if @product.update_status
      @product.product_info_translations.try(:destroy_all)
      @product.variables.try(:destroy_all)
      @product.destroy
      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      @product.product_info_translations.try(:destroy_all)
      @product.variables.try(:destroy_all)
      @product.destroy
      respond_to do |format|
        format.html { redirect_to un_updated_page_products_url, notice: 'Product was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:product_type_id, :title, :sku, :sku_number, :product_number, :user_id, :origin_address, 
                                      :desc1, :desc2, :desc3, :brand, :price, :on_sale, :translate_status, :product_from,
                                      :details, :producer, :heel_height, :closure_type, :heel_type, :sole_material, :inner_material_type,
                                      :outer_material_type, :update_status, :seasons, :images1, :images2, :images3, :images4, :images5,
                                      :images6, :images7, :images8, :images9, :images10, :images11, :images12, :images13, :images14, :images15,
                                      :images16, :images17, :images18, :images19, :images20, :images21, :images22, :images23, :images24, :images25,
                                      :images26, :images27, :images28, :images29, :images30, :image_cut_x, :image_cut_y, :image_cut_position,
                                      :shield_type, :shop_id, :shield_untill, :presale_date, :strap_type, :lining_description, :shoe_width,
                                      :platform_height, :shaft_diameter, :shaft_height, :leather_type, :style_name, :department_name, :purchase_link,
                                      :product_weight, :editing_backup, :avatar, :avatar1, :avatar2, :stock)
    end

    def avaliable? link
      TmallLink.avaliable? link
    end
end
