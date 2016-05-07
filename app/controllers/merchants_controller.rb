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
    merchant_sku_relation_test_array = []
    a = Time.now
    pre_product = ''
    pre_sku = 'FLAGNIL'
    product_sku_array = product_sku.split("\n")
    product_sku_array.each do |sku|
      sku_part = sku[0..7]
      if pre_product != 'FLAGNIL' && pre_sku == sku_part
        product = pre_product
      else
        product = Product.find_by(sku: sku_part)
        pre_product = product
        pre_sku = sku_part
      end
      # if sku.present?
      #   # unless MerchantSkuRelation.find_by(sku: sku, merchant_id: @merchant.id)
      #     merchant_sku_hash = {}
      #     merchant_sku_hash[:merchant_id] = @merchant.id
      #     merchant_sku_hash[:sku] = sku
      #     merchant_sku_hash[:product_id] = product.try(:id)
      #     merchant_sku_relation_array << merchant_sku_hash
      #   # end
      # end
      create_time = Time.now.strftime("%Y-%m-%d")
      if product.present?
        merchant_sku_relation_test_array << "('#{@merchant.id}', '#{product.try(:id)}', '#{sku}', '#{create_time}', '#{create_time}')"
      else
        merchant_sku_relation_test_array << "('#{@merchant.id}', NULL, '#{sku}', '#{create_time}', '#{create_time}')"
      end
    end
    # MerchantSkuRelation.create(merchant_sku_relation_array)
    abc = merchant_sku_relation_test_array.split(',').flatten
    aaa = "insert into merchant_sku_relations (merchant_id, product_id, sku, created_at, updated_at) values"
    aaab = ''
    abc.each do |bc|
      aaab << bc +','
    end
    aaa = aaa + aaab[0..-2] + ';'
    count = merchant_sku_relation_test_array.count + 1
    connection = ActiveRecord::Base.connection
    connection.execute(aaa)
    puts Time.now - a
    puts count
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
