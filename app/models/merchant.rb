class Merchant < ActiveRecord::Base
  belongs_to :user
  belongs_to :account

  has_many :merchant_sku_relations
  has_many :orders

  scope :not_removed, -> {where(is_removed: false)}

  def reset_all_sku_price
    ProductBasicInfo.where("sku in (?)", merchant_sku_relations.select(:sku).map(&:sku)).update_all("#{self.merchant_country_name}_price_change".to_sym => true)
  end

  def get_merchant_products(return_type=false)
    old_sku_array, new_sku_array = [], []
    merchant_sku_relations.select(:sku).map(&:sku).map do |a|
      if a.first == 'M'
        old_sku_array << a
      else
        # offset = 8 - a.index('-').to_i
        new_sku_array << a[0..35]
      end
    end
    if return_type
      [ProductBasicInfo.where("sku in (?)", old_sku_array), ProductBasicInfo.where("sku1 in (?)", new_sku_array)]
    else
      ProductBasicInfo.where("sku in (?) or sku1 in (?)", old_sku_array, new_sku_array)
    end
  end

  def removed?
    !!self.is_removed
  end
end
