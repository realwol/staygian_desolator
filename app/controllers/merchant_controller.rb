class MerchantController < ApplicationController
  def index
    @merchants = current_user.valid_merchants
  end

  def create
    binding.pry
    current_user.merchants.create(merchant_params)
    @merchants = current_user.valid_merchants
  end

  def remove
    merchant = Merchant.find(params[:id])
    if merchant.present?
      merchant.destroy
    end
    render json:true
  end

  private
  def merchant_params
    params.permit(:shop_name, :merchant_plantform_name, :merchant_account, :merchant_country_name, :merchant_type, :merchant_aws_access_key_id, :merchant_secret_key, :merchant_seller_id, :merchant_marketplace_id, :merchant_api_address)
  end
end
