class ShipmentMethod < ActiveRecord::Base
  has_many :shipment_method_values
end
