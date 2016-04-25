class TmallLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :shop

  scope :zero_shop, -> {where(shop_id: 0)}

  def self.avaliable? link
  	!all.where(address:link).last
  end

end
