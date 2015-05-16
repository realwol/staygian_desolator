class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :shield_product, :presale_product]
  before_action :authenticate_user!

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
    @products = Product.where(product_type_id: params[:export_type]).order('created_at desc')
    cookies[:export_language] = params[:language]
    cookies[:export_type] = params[:export_type]
    request.format = 'xls'
    respond_to do |f|
      f.xls {send_data @products.to_csv(params[:language], col_sep: "\t")}
      # f.xls
    end
  end

  def off_sale_products
    @products = Product.offsale.page(params[:page])
  end

  def shield_products
    @products = Product.shield.page(params[:page])
  end

  def shield_product
    @product.update_attributes(shield_type:'1')
    redirect_to root_path
  end

  def presaled_products
    @products = Product.pre_saled.page(params[:page])
  end

  def presale_product
    @product.update_attributes(shield_type:'2', presale_date: params[:presale_date])
    redirect_to root_path
  end

  def un_updated_page
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
    @products = Product.all.updated.un_shield.order('id desc').page(params[:page])
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
      product_params["user_id"] = current_user.id
      if @product.update(product_params)
        @product.update_attributes(update_status:true)
        Variable.update_product_variable(params["variable"], @product)
        TranslateToken.create(t_id:@product.id, t_type:'product', t_status: true, t_method:'update')
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
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
                                      :outer_material_type, :update_status, :seasons, :images1, :images2, :images3, :images4, :images5)
    end

    def avaliable? link
      TmallLink.avaliable? link
    end
end
