class Merchant < ActiveRecord::Base
  belongs_to :user

  has_many :merchant_sku_relations

  def reset_all_sku_price
    relations = self.merchant_sku_relations
    a = []
    relations.each do |relation|
      info = ProductBasicInfo.find_by(sku: relation.sku)
      a << info.id if info.present?
    end
    merchant_products_basic_infos = ProductBasicInfo.where(id: a)

    merchant_products_basic_infos.update_all("#{self.merchant_country_name}_price_change".to_sym => true)
  end
end
