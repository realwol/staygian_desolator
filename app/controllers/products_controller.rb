class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def un_updated_page
    @products = Product.all.unscope(:where).un_updated.page(params[:page])
  end

  def get_tmall_links
    
  end

  def save_tmall_links
    t = Time.now
    links_array = []
    link_hash = {}
    params[:links].split("\r\n").each do |link|
      if avaliable?(link)
        link_hash.clear
        link_hash[:address] = link
        link_hash[:user_id] = current_user.id
        link_hash[:status]  = false
        links_array << link_hash.dup
      end
    end
    TmallLink.create(links_array)
    puts Time.now - t

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
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
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
