class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :shield_product, :presale_product, :offsale_product, :temp_offsale_product, :onsale_product]
  before_action :authenticate_user!

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
    @result[:type] = product_type = params[:search_type]
    @result[:shop] = product_shop = params[:product_shop]
    @result[:brand] = product_brand = params[:product_brand]
    @result[:sku] = sku_value = params[:sku_value]
    @action_from = params[:action_from]

    @products = Product.all
    search_query = []
    unless product_type.empty?
      search_query << "product_type_id = '#{product_type}'"
    end

    unless product_shop.empty?
      shop = Shop.where(name:product_shop).first
      @products = shop.products if shop
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
    when 'temp_offsale_products'
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
    start_sku = params[:start_sku]
    if start_sku.blank?
      @products = Product.where("product_type_id = ?", params[:export_type]).order('id desc').limit(1000)
    else
      start_product = Product.where(sku:start_sku).last

      unless start_product
        redirect_to export_page_products_url, notice:'Sku错误'
        return
      end
      
      unless start_product.try(:product_type_id) == params[:export_type].to_i
        redirect_to export_page_products_url, notice:'Sku与所选分类不匹配'
        return
      end

      @products = Product.where("product_type_id = ? and first_updated_time > ?", params[:export_type], start_product.first_updated_time).order('id desc').limit(1000)
    end
    cookies[:export_language] = params[:language]
    cookies[:export_type] = params[:export_type]
    request.format = 'xls'
    respond_to do |f|
      f.xls {send_data @products.to_csv(params[:language], col_sep: "\t")}
      # f.xls
    end
  end

  def onsale_product
    @product.update_attributes(on_sale:true, shield_type:0)
    redirect_to root_path
  end

  def off_sale_products
    @action_from = params[:action]
    @products = Product.offsale.page(params[:page])
  end

  def off_sale_all
    unless params[:all_offsale_products].blank?
      Product.where(id:params[:all_offsale_products].split(' ')).update_all(shield_type:0, on_sale:false)
    end
    redirect_to root_path
  end

  def temp_off_sale_products
    @products = Product.temp_offsale.page(params[:page])
  end

  def temp_off_sale_all
    unless params[:all_products].blank?
      Product.where(id:params[:all_products].split(' ')).update_all(shield_type:3, on_sale:false)
    end
    redirect_to root_path
  end

  def offsale_product
    @product.update_attributes(on_sale:false, shield_type: 0)
    redirect_to off_sale_products_products_url
  end

  def temp_offsale_product
    @product.update_attributes(shield_type:3, on_sale:false)
    redirect_to temp_off_sale_products_products_url
  end

  def shield_products
    @action_from = params[:action]
    @products = Product.shield.page(params[:page])
  end

  def shield_product
    @product.update_attributes(shield_type:'1', on_sale:false)
    redirect_to shield_products_products_path
  end

  def presaled_products
    @action_from = params[:action]
    @products = Product.pre_saled.page(params[:page])
  end

  def presale_product
    @product.update_attributes(shield_type:'2', presale_date: params[:presale_date], on_sale:false)
    redirect_to presaled_products_products_url
  end

  def un_updated_page
    @action_from = params[:action]
    @products = Product.all.un_updated.page(params[:page])
  end

  def get_tmall_links 
    @shops = current_user.shops.page(params[:page])
  end

  # Move grasp tmall_links to a rake task and keep one shop in 60-80 sec
  def save_tmall_links
    unless Shop.shop_avaliable? params[:links]
      redirect_to root_path and return 
    end
    link = "http://list.tmall.com/search_shopitem.htm?user_id=" + params[:links]
    unless params[:shop_name].blank?
      shop = Shop.create(name:params[:shop_name], user_id: current_user.id, status:true, shop_from: 'tmall', shop_id: params[:links])
    end
    ShopLink.create(shop_id_string:params[:links], link:link, user: current_user, status: 0, shop_id: shop.try(:id))
    redirect_to root_path
  end

  def index
    @action_from = params[:action]
    @products = Product.all.updated.onsale.un_shield.order('first_updated_time desc').page(params[:page])
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
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.update_attributes(user_id: current_user.id)
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
    respond_to do |format|
      if @product.update(product_params)
        if @product.first_updated_time
          @product.update_attributes(update_status:true, user_id: current_user.id)
        else
          @product.update_attributes(update_status:true, user_id: current_user.id, first_updated_time: Time.now)
        end
        # Tobe cut
        if params[:cut_image_urls][2..-1]
          cut_image_urls = params[:cut_image_urls][2..-1].split('|')
          cut_image_urls.each do |url|
            QiniuUploadHelper::QiNiu.update(url, @product.image_cut_position, @product.image_cut_x, @product.image_cut_y)
          end
        end

        Variable.update_product_variable(params["variable"], @product)
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
      @product.destroy
      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
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
                                      :shield_type, :shop_id, :shield_untill, :presale_date)
    end

    def avaliable? link
      TmallLink.avaliable? link
    end
end
