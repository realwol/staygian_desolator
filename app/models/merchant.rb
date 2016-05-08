class Merchant < ActiveRecord::Base
  belongs_to :user

  has_many :merchant_sku_relations

  def reset_all_sku_price
    ProductBasicInfo.where("sku in (?)", merchant_sku_relations.map(&:sku)).update_all("#{self.merchant_country_name}_price_change".to_sym => true)
  end
end
