class MerchantsController < ApplicationController
  before_action :set_merchant, only: [:edit, :update, :stop_merchant, :destroy, :add_merchant_product, :update_shipment_cost]

  def update_shipment_cost
    unless @merchant.shipment_cost == params[:shipment_cost]
      @merchant.update_attributes(shipment_cost: params[:shipment_cost])
      @merchant.reset_all_sku_price
    end
    render json:true
  end

  def index
    @merchants = current_user.valid_merchants
  end

  def create
    mws_points = {america: 'https://mws.amazonservices.com', canada: 'https://mws.amazonservices.ca', british: 'https://mws-eu.amazonservices.com', germany: 'https://mws-eu.amazonservices.com', spain: 'https://mws-eu.amazonservices.com', italy: 'https://mws-eu.amazonservices.com', france: 'https://mws-eu.amazonservices.com' }
    params[:merchant_api_address] = mws_points["#{merchant_params[:merchant_country_name]}".to_sym]
    current_user.merchants.create(merchant_params)
    @merchants = current_user.valid_merchants
  end

  def edit
  end

  def update
    @merchant.update_attributes(merchant_params)
    redirect_to action: :index
  end

  def stop_merchant
    @merchant.update_attributes(status: false)
    render json:true
  end

  def add_merchant_product
    product_sku = params[:product_sku]
    merchant_sku_relation_array = []
    product_sku.split("\n").each do |sku|
      product = Product.where(sku: sku[0..7]).first
      if sku.present?
        unless MerchantSkuRelation.where(sku: sku, merchant_id: @merchant.id).first
          merchant_sku_hash = {}
          merchant_sku_hash[:merchant_id] = @merchant.id
          merchant_sku_hash[:sku] = sku
          merchant_sku_hash[:product_id] = product.id
          merchant_sku_relation_array << merchant_sku_hash
        end
      end
    end
    MerchantSkuRelation.create(merchant_sku_relation_array)
    render json:true
  end

  def destroy
    if @merchant.present?
      @merchant.destroy
    end
    render json:true
  end

  private
  def merchant_params
    params.permit(:shop_name, :merchant_plantform_name, :merchant_account, :merchant_country_name, :merchant_type, :merchant_aws_access_key_id, :merchant_secret_key, :merchant_seller_id, :merchant_marketplace_id, :merchant_api_address)
  end

  def set_merchant
    @merchant = Merchant.find(params[:id])
  end
end
