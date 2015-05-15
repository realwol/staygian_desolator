class ProductInfoTranslation < ActiveRecord::Base
	acts_as_paranoid
  belongs_to :product
end
