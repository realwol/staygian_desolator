class ProductTypesController < ApplicationController
  before_action :set_product_type, only: [:show, :edit, :update, :destroy]

  def update_type_introduction
    introduction_1_array = params[:introduction_1].split(',')
    introduction_2_array = params[:introduction_2].split(',')
    introduction_1 = AttributesTranslationHistory.create(china: introduction_1_array[0],
                                                          america: introduction_1_array[1],
                                                          canada: introduction_1_array[2],
                                                          british: introduction_1_array[3],
                                                          germay: introduction_1_array[4],
                                                          france: introduction_1_array[5],
                                                          spain: introduction_1_array[6],
                                                          italy: introduction_1_array[7])
    introduction_2 = AttributesTranslationHistory.create(china: introduction_2_array[0],
                                                          america: introduction_2_array[1],
                                                          canada: introduction_2_array[2],
                                                          british: introduction_2_array[3],
                                                          germay: introduction_2_array[4],
                                                          france: introduction_2_array[5],
                                                          spain: introduction_2_array[6],
                                                          italy: introduction_2_array[7])
    ProductType.find(params[:id]).update_attributes(product_type_introduction_1: introduction_1.id, product_type_introduction_2: introduction_2.id)
    render json: true
  end

  def update_type_setting
    type_setting_values = params[:type_values].split(',')
    feed_attribute_values, type1_attribute_values, type2_attribute_values = type_setting_values[0..7], type_setting_values[8..15], type_setting_values[16..23]

    attribute_feed = AttributesTranslationHistory.create(china: feed_attribute_values[0],
                                                          america: feed_attribute_values[1],
                                                          canada: feed_attribute_values[2],
                                                          british: feed_attribute_values[3],
                                                          germay: feed_attribute_values[4],
                                                          france: feed_attribute_values[5],
                                                          spain: feed_attribute_values[6],
                                                          italy: feed_attribute_values[7])
    attribute_type1 = AttributesTranslationHistory.create(china: type1_attribute_values[0],
                                                          america: type1_attribute_values[1],
                                                          canada: type1_attribute_values[2],
                                                          british: type1_attribute_values[3],
                                                          germay: type1_attribute_values[4],
                                                          france: type1_attribute_values[5],
                                                          spain: type1_attribute_values[6],
                                                          italy: type1_attribute_values[7])
    attribute_type2 = AttributesTranslationHistory.create(china: type2_attribute_values[0],
                                                          america: type2_attribute_values[1],
                                                          canada: type2_attribute_values[2],
                                                          british: type2_attribute_values[3],
                                                          germay: type2_attribute_values[4],
                                                          france: type2_attribute_values[5],
                                                          spain: type2_attribute_values[6],
                                                          italy: type2_attribute_values[7])
    ProductType.find(params[:id]).update_attributes(product_type_feed: attribute_feed.id, product_type_1: attribute_type1.id, product_type_2: attribute_type2.id)
    render json: true
  end

  def update_description
    attribute_translation = AttributesTranslationHistory.create(china: params[:descriptionTextArea0],
                                                          america: params[:descriptionTextArea1],
                                                          canada: params[:descriptionTextArea2],
                                                          british: params[:descriptionTextArea3],
                                                          germay: params[:descriptionTextArea4],
                                                          france: params[:descriptionTextArea5],
                                                          spain: params[:descriptionTextArea6],
                                                          italy: params[:descriptionTextArea7])
    ProductType.find(params[:id]).update_attributes(product_type_description: attribute_translation.id)
    render json: true
  end

  def update_price_setting
    price_values_array = params[:price_value].split(',')
    attribute_translation = AttributesTranslationHistory.create(china: price_values_array[0],
                                                          america: price_values_array[1],
                                                          canada: price_values_array[2],
                                                          british: price_values_array[3],
                                                          germay: price_values_array[4],
                                                          france: price_values_array[5],
                                                          spain: price_values_array[6],
                                                          italy: price_values_array[7])
    ProductType.find(params[:id]).update_attributes(price_translation: attribute_translation.id)
    render json: true
  end
  
  def update_product_type_attribute
    attributes_value_array = params[:attributes_value].split(',')
    product_attribute_is_locked = attributes_value_array[1].present?
    if params[:attribute_id].present?
      product_attribute = ProductAttribute.find(params[:attribute_id])
      product_attribute.update_attributes(attribute_name: attributes_value_array[0], is_locked: product_attribute_is_locked, table_name: attributes_value_array[2], product_type_id: params[:id])
      product_attribute.attributes_translation_history.update_attributes(attribute_name: attributes_value_array[0], china: attributes_value_array[3], america: attributes_value_array[4], canada: attributes_value_array[5], british: attributes_value_array[6], germay: attributes_value_array[7], spain: attributes_value_array[9], italy: attributes_value_array[10], france: attributes_value_array[8])
    else
      product_attribute = ProductAttribute.where(attribute_name: attributes_value_array[0]).first
      product_attribute = ProductAttribute.create(attribute_name: attributes_value_array[0], is_locked: product_attribute_is_locked, table_name: attributes_value_array[2], product_type_id: params[:id]) unless product_attribute.present?
      AttributesTranslationHistory.create(attribute_name: attributes_value_array[0], china: attributes_value_array[3], america: attributes_value_array[4], canada: attributes_value_array[5], british: attributes_value_array[6], germay: attributes_value_array[7], spain: attributes_value_array[9], italy: attributes_value_array[10], france: attributes_value_array[8], product_attribute_id: product_attribute.id)
    end
    @product_type_attributes = ProductAttribute.all
  end

  def update_shipment_method
    
    shipment_method_china = ShipmentMethod.find(params[:shipment_method_china])
    shipment_method_america = ShipmentMethod.find(params[:shipment_method_america])
    shipment_method_canada = ShipmentMethod.find(params[:shipment_method_canada])
    shipment_method_british = ShipmentMethod.find(params[:shipment_method_british])
    shipment_method_germany = ShipmentMethod.find(params[:shipment_method_germany])
    shipment_method_france = ShipmentMethod.find(params[:shipment_method_france])
    shipment_method_spain = ShipmentMethod.find(params[:shipment_method_spain])
    shipment_method_italy = ShipmentMethod.find(params[:shipment_method_italy])

    attribute_translation = AttributesTranslationHistory.create(china: shipment_method_china.id,
                                        america: shipment_method_america.id,
                                        canada: shipment_method_canada.id,
                                        british: shipment_method_british.id,
                                        germay: shipment_method_germany.id,
                                        france: shipment_method_france.id,
                                        spain: shipment_method_spain.id,
                                        italy: shipment_method_italy.id)
    ProductType.find(params[:id]).update_attributes(shipment_translation: attribute_translation.id)
    render json: true
  end

  def index
    @product_types = ProductType.all
  end

  def show
  end

  def new
    @product_type = ProductType.new
  end

  def edit
    @shipment_methods = ShipmentMethod.all
    @product_type_attributes = ProductAttribute.all
  end

  def create
    @product_type = ProductType.new(product_type_params)

    respond_to do |format|
      if @product_type.save
        format.html { redirect_to @product_type, notice: 'Product type was successfully created.' }
        format.json { render :show, status: :created, location: @product_type }
      else
        format.html { render :new }
        format.json { render json: @product_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product_type.update(product_type_params)
        format.html { redirect_to @product_type, notice: 'Product type was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_type }
      else
        format.html { render :edit }
        format.json { render json: @product_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_type.destroy
    respond_to do |format|
      format.html { redirect_to product_types_url, notice: 'Product type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_product_type_attribute
    product_attribute = ProductAttribute.find(params[:id])
    if product_attribute
      product_attribute.destroy
    end
    @product_type_attributes = ProductAttribute.all
  end

  private
    def set_product_type
      @product_type = ProductType.find(params[:id])
    end

    def product_type_params
      params.require(:product_type).permit(:name, :father_node, :deleted_at)
    end
end
