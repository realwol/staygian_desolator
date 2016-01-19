class ShipmentsController < ApplicationController
  def index
    @shipment_methods = ShipmentMethod.order("id desc").page(params[:page])
  end

  def create
    ShipmentMethod.create(name: params[:name])
    @shipment_methods = ShipmentMethod.order("id desc").page(params[:page])
  end

  def destroy
    ShipmentMethod.delete(params[:id])
    @shipment_methods = ShipmentMethod.order("id desc").page(params[:page])
  end

  def edit
    @shipment_method = ShipmentMethod.find(params[:id])
    @shipment_id = params[:id]
  end

  def save_shipment_value
    shipment_value_array = params[:shipment_method_value].split(',')
    if params[:id].present?
      ShipmentMethodValue.find(params[:id]).update_attributes(weight: shipment_value_array[0], america_price: shipment_value_array[1], canada_price: shipment_value_array[2], british_price: shipment_value_array[3], germany_price: shipment_value_array[4],italy_price: shipment_value_array[5], spain_price: shipment_value_array[6], france_price: shipment_value_array[7], shipment_method_id: params[:shipment_method_id])
    else
      ShipmentMethodValue.create(weight: shipment_value_array[0], america_price: shipment_value_array[1], canada_price: shipment_value_array[2], british_price: shipment_value_array[3], germany_price: shipment_value_array[4],italy_price: shipment_value_array[5], spain_price: shipment_value_array[6], france_price: shipment_value_array[7], shipment_method_id: params[:shipment_method_id])
    end
    @shipment_method = ShipmentMethod.find(params[:shipment_method_id])
  end

  def delete_shipment_method_value
    ShipmentMethodValue.delete(params[:id])
  end
end