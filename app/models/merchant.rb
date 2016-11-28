class Merchant < ActiveRecord::Base
  belongs_to :user
  belongs_to :account

  has_many :merchant_sku_relations
  has_many :orders

  scope :not_removed, -> {where(is_removed: false)}

  def reset_all_sku_price
    ProductBasicInfo.where("sku in (?)", merchant_sku_relations.select(:sku).map(&:sku)).update_all("#{self.merchant_country_name}_price_change".to_sym => true)
  end

  def get_merchant_products
    sku_array = merchant_sku_relations.select(:sku).map(&:sku)
    ProductBasicInfo.where("sku in (?)", sku_array)
  end

  def removed?
    !!self.is_removed
  end
end
