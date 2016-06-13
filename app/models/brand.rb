class Brand < ActiveRecord::Base
  has_many :brand_shop_relations
  has_many :shops, through: :brand_shop_relations
  has_many :vendors
  has_many :products

  scope :non_forbidden, -> {where(status: 0)}
  scope :forbidden, -> {where(status: 1)}

  def get_brand_stand_by_shops
    stand_by_shop_ids = self.brand_shop_relations.where(status: '5').pluck(:shop_id)
    Shop.where("id in (?) ", stand_by_shop_ids)
  end

  def get_brand_connect_shops
    stand_by_shop_ids = self.brand_shop_relations.where(status: '1').pluck(:shop_id)
    Shop.where("id in (?) ", stand_by_shop_ids)
  end

  def get_brand_forbidden_shops
    stand_by_shop_ids = self.brand_shop_relations.where(status: '2').pluck(:shop_id)
    Shop.where("id in (?) ", stand_by_shop_ids)
  end
  
end
