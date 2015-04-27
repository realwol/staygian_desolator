class Product < ActiveRecord::Base
	acts_as_paranoid
  belongs_to :product_type
  belongs_to :user

  has_many :variables
  accepts_nested_attributes_for :variables

  has_one :product_info_translation

  scope :un_updated, -> {where(update_status:false).order("id desc")}
  scope :updated, -> {where(update_status:true)}

  before_create :save_sku

  def valid_images
  	image_names = []
  	1.upto(10) do |t|
  		image_names << "images#{t}"
  	end

  	@valid_images = []
  	image_names.each do |attr|
  		@valid_images << self.read_attribute("#{attr}") unless self.read_attribute("#{attr}").blank?
  	end

  	@valid_images
  end

  private

  def save_sku
    # get the last product's sku then add one on it
    if Product.with_deleted.count == 0
      base_number = 0
    else
      base_number = Product.unscope(:where).with_deleted.last.sku_number.to_i
    end
    self.sku_number = base_number + 1

    self.sku = self.sku_number.to_s.prepend(("T" + "0" * (7- self.sku_number.to_s.length)) )
  end
end
