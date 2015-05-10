class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :shield_product]
  before_action :authenticate_user!

  def shield_product
    @product.update_attributes(product_from:'1')
    redirect_to root_path
  end

  def un_updated_page
    @products = Product.all.un_updated.page(params[:page])
  end

  def get_tmall_links
    
  end

  def save_tmall_links
    links_array = []
    link_hash = {}
    agent = Mechanize.new
    uri = params[:links]
    redirect_to root_path if uri.blank?

    shop_id = nil
    unless params[:shop_name].blank?
      shop = Shop.create(name:params[:shop_name], user_id: current_user, status:true)
      shop_id = shop.id
    end

    page = agent.get(uri)
    a = page.at('#J_ItemList').children

    1.step(a.count - 2,2) do |i|
      link_hash[:address] = "http://" + a[i].at('a.productImg').attributes["href"].value[2..-1]
      product_link_start = link_hash[:address].index('id') + 3
      product_link_end = link_hash[:address][product_link_start..-1].index('&') - 1 + product_link_start

      product_link_id = link_hash[:address][product_link_start..product_link_end]
      unless TmallLink.where(product_link_id: product_link_id).first
        link_hash[:product_link_id] = product_link_id
        link_hash[:user_id] = current_user.id
        link_hash[:status]  = false
        link_hash[:shop_id]  = (shop_id || params[:product][:shop_id])
        links_array << link_hash.dup
      end
    end

    TmallLink.create(links_array)

    redirect_to root_path
  end

  def index
    @products = Product.all.updated.page(params[:page])
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
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
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
                                      :outer_material_type, :update_status)
    end

    def avaliable? link
      TmallLink.avaliable? link
    end
end
