class Merchant < ActiveRecord::Base
  belongs_to :user
  belongs_to :account

  has_many :merchant_sku_relations

  def reset_all_sku_price
    ProductBasicInfo.where("sku in (?)", merchant_sku_relations.map(&:sku)).update_all("#{self.merchant_country_name}_price_change".to_sym => true)
  end

  def get_merchant_products
    ProductBasicInfo.where("sku in (?)", merchant_sku_relations.map(&:sku))
  end
end
