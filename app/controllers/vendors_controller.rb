class VendorsController < ApplicationController
  before_action :set_vendor, only: [:show, :edit, :update, :destroy, :update_vendor_info, :remove_vendor_info]

  def search_by_condition
    shop_name = params[:shop_name]
    brand_name = params[:brand_name]
    @vendors = []
    @vendors = Vendor.valid_vendor if shop_name.present? || brand_name.present?
    if shop_name.present?
      shop = Shop.find_by(name: shop_name)
      @vendors = @vendors.where(shop_id: shop.try(:id))
    end

    if brand_name.present?
      brand = Brand.find_by(name: brand_name)
      @vendors = @vendors.where(brand_id: brand.try(:id))
    end

    @vendors = @vendors.order(:brand_id).page params[:page]
  end

  def update_vendor_info
    @vendor.update_attributes(vendor_update_params)
    render json:true
  end

  def remove_vendor_info
    @vendor.update_attributes(status: false)
    render json:true
  end

  def index
    @vendors = current_user.valid_vendors.order(:brand_id).page params[:page]
  end

  def show
  end

  def new
    @vendor = Vendor.new
  end

  def edit
  end

  def create
    @vendor = Vendor.new(vendor_params)

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to @vendor, notice: 'Vendor was successfully created.' }
        format.json { render :show, status: :created, location: @vendor }
      else
        format.html { render :new }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @vendor.update(vendor_params)
        format.html { redirect_to @vendor, notice: 'Vendor was successfully updated.' }
        format.json { render :show, status: :ok, location: @vendor }
      else
        format.html { render :edit }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @vendor.destroy
    respond_to do |format|
      format.html { redirect_to vendors_url, notice: 'Vendor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    def vendor_params
      params.require(:vendor).permit(:name, :brand_id, :purchase_address, :contact, :backup)
    end

    def vendor_update_params
      params.permit(:name, :purchase_address, :contact, :backup)
    end
end
