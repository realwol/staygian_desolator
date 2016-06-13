class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :edit, :update, :destroy, :update_brand_english_name, :forbidden_brand, :update_brand_shop_status, :recover_brand]

  def recover_brand
    @brand.update_attributes(status: 1)
    @brand.products.update_all(shield_type: 0)

    @brands = Brand.forbidden
  end

  def forbidden_brand_list
    @brands = Brand.forbidden
  end

  def update_brand_english_name
    @brand.update_attributes(english_name: params[:brand_english_name].strip)
    render json:true
  end

  def forbidden_brand
    @brand.update_attributes(status: 0)
    @brand.products.update_all(shield_type: 1)

    @brands = Brand.non_forbidden
  end

  def update_brand_shop_status
    shop_ids = params[:shop_ids][0..-2].split('|')
    brand_shop_relations = @brand.brand_shop_relations.where("shop_id in (?)", shop_ids)
    brand_shop_relations.update_all(status: params[:status_string]) if brand_shop_relations.present?

    # update brand products by the status of brand
    update_shops = Shop.where("id in (?)", shop_ids)
    if update_shops.present?
      case params[:status_string].to_i
      when 2
        # make product shield when brand forbidden
        # Shop.update_shield_type update_shops, 1
        # remove all products under the shop
        update_shops.update_all(status: false)
        update_shops.each do |shop|
          shop.products.each do |product|
            # product.variables
            product.variables.destroy_all
            product.product_info_translations.destroy_all
            product.destroy
          end
          shop.tmall_links.destroy_all
        end
      when 1
        update_shops.update_all(status: true)
        Shop.update_shield_type update_shops, 0
      when 5
        update_shops.update_all(status: true)
        Shop.update_shield_type update_shops, 5
      end
    end

    # create vendor in brand_shop_relation update
    brand_connect_shops = @brand.get_brand_connect_shops
    Vendor.where(brand_id: @brand.id).each do |vendor|
      unless brand_connect_shops.map(&:id).index(vendor.shop_id).present?
        vendor.update_attributes(status: 0)
      end
    end

    brand_connect_shops.each do |brand_shop|
      vendor = Vendor.where("brand_id = ? and shop_id = ?", @brand.id, brand_shop.id).first
      if vendor.present?
        vendor.update_attributes(status: 1)
      else
        Vendor.create(name: brand_shop.try(:name), brand_id: @brand.id, shop_id: brand_shop.id)
      end
    end

    brand_shops = @brand.shops
    @stand_by_shops = brand_shops.where(status: '')
    # render json:true
  end

  def index
    @brands = Brand.non_forbidden
  end

  def show
    brand_shops = @brand.shops
    @stand_by_shops = brand_shops.where(status: '')
  end

  def new
    @brand = Brand.new
  end

  def edit
  end

  def create
    @brand = Brand.new(brand_params)

    respond_to do |format|
      if @brand.save
        format.html { redirect_to @brand, notice: 'Brand was successfully created.' }
        format.json { render :show, status: :created, location: @brand }
      else
        format.html { render :new }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @brand.update(brand_params)
        format.html { redirect_to @brand, notice: 'Brand was successfully updated.' }
        format.json { render :show, status: :ok, location: @brand }
      else
        format.html { render :edit }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @brand.destroy
    respond_to do |format|
      format.html { redirect_to brands_url, notice: 'Brand was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brand
      @brand = Brand.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brand_params
      params.require(:brand).permit(:name, :english_name, :status)
    end
end
