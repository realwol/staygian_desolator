class TmallLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :shop
  belongs_to :search_link

  scope :zero_shop, -> {where(shop_id: 0)}

  # tmall link product status 0 for normal 1 for shield

  def self.avaliable? link
  	!all.where(address:link).last
  end

end
