class ProductTypesController < ApplicationController
  before_action :set_product_type, only: [:show, :edit, :update, :destroy, :update_product_type_attribute, :update_final_type, :update_key_words, :update_product_type_translation]
  
  def search_des_translation
    desc_name = params[:desc_name]
    @descriptions = DescriptionTranslationHistory.where(" description like ? ", "%#{desc_name}%").order('usage_count desc').page(params[:page])
    @switch = 0
  end

  def description_translation_history_page
    @descriptions = DescriptionTranslationHistory.order('usage_count desc').page(params[:page])
    @switch = 1
  end

  def switch_description_translation_history_page
    @table_id = params[:table_id].to_i
    case @table_id
    when 1
      @descriptions = DescriptionTranslationHistory.order('usage_count desc').page(params[:page])
    when 2
      @descriptions = DescriptionTranslationHistory.order(:america, usage_count: :desc).page(params[:page])
    when 3
      @descriptions = DescriptionTranslationHistory.order(created_at: :desc).page(params[:page])
    end
    @switch = 0
  end

  def remove_desc_translation
    if params[:desc_translation_id].present?
      DescriptionTranslationHistory.find(params[:desc_translation_id]).destroy
    end
    render json:true
  end

  def save_desc_translation
    @new_flag = true
    attribute_value_array = params[:attribute_value].strip.gsub('，', ',').gsub('、',',').gsub('。', '.').gsub("\r", '').gsub("\n",'').split('|')
    if params[:desc_translation_id].present?
      # update
      DescriptionTranslationHistory.find(params[:desc_translation_id]).update_attributes(description: attribute_value_array[0], 
                                         china: attribute_value_array[0], america: attribute_value_array[1], canada: attribute_value_array[1],
                                         british: attribute_value_array[2],germany: attribute_value_array[3], spain: attribute_value_array[4],
                                         italy: attribute_value_array[5], france: attribute_value_array[6])
    else
      if DescriptionTranslationHistory.where(description: attribute_value_array[0]).count > 0
        @new_flag = false
      else
        DescriptionTranslationHistory.create(description: attribute_value_array[0], china: attribute_value_array[0], america: attribute_value_array[1],
                                             canada: attribute_value_array[1], british: attribute_value_array[2], germany: attribute_value_array[3],
                                             spain: attribute_value_array[4],italy: attribute_value_array[5], france: attribute_value_array[6])
      end
    end
    @descriptions = DescriptionTranslationHistory.order('usage_count desc').page(params[:page])
  end

  def get_children_product_types
    if params[:product_type_id].present?
      if params[:ajax_action_from].present? && params[:ajax_action_from] == 'level2Click'
        product_type = ProductType.find(params[:product_type_id])
        if product_type.father_node == '0'
          @children_product_types = ProductType.where(father_node: '0')
        else
          @children_product_types = ProductType.find(product_type.father_node).children_product_types
        end
      else
        @children_product_types = ProductType.find(params[:product_type_id]).children_product_types
      end
    end
  end

  def update_product_type_translation
    if @product_type.product_type_name_translation.present?
      translation_history = AttributesTranslationHistory.find(@product_type.product_type_name_translation)
      translation_history.update_attributes(china: @product_type.name, america: params[:name_america], canada: params[:name_canada], british: params[:name_british], germany: params[:name_germany], spain: params[:name_spain], italy: params[:name_italy], france: params[:name_france])
    else
      translation_history = AttributesTranslationHistory.create(china: @product_type.name, america: params[:name_america], canada: params[:name_canada], british: params[:name_british], germany: params[:name_germany], spain: params[:name_spain], italy: params[:name_italy], france: params[:name_france])
      @product_type.update_attributes(product_type_name_translation: translation_history.id)
    end
  end

  def update_key_words
    update_hash = {}
    [params["0"], params["1"], params["2"], params["3"], params["4"]].each_with_index do |params, index|
      translation_history = AttributesTranslationHistory.create(america: params[:key_word_america], canada: params[:key_word_canada], british: params[:key_word_british], germany: params[:key_word_germany], spain: params[:key_word_spain], italy: params[:key_word_italy], france: params[:key_word_france])
      update_hash["#{index}"] = translation_history.id
    end

    @product_type.update_attributes(key_word1_translation: update_hash["0"], key_word2_translation: update_hash["1"], key_word3_translation: update_hash["2"], key_word4_translation: update_hash["3"], key_word5_translation: update_hash["4"])

  end

  def update_final_type
    if params[:checked_or_not] == 'checked'
      if @product_type.children_product_types.count < 1
        @product_type.update_attributes(is_final_type: true)
        render json: 3
      else
        render json: 2
      end
    else
      if @product_type.products.count < 1
        @product_type.update_attributes(is_final_type: false)
        render json: 4
      else
        render json: 1
      end
    end
    @product_type_father_node = params[:father_node] || '0'
    @product_types = ProductType.where(father_node: @product_type_father_node)
  end

  def next_product_types_list
    product_type = ProductType.find(params[:id])
    @product_type_father_node = params[:id]
    @product_types = product_type.children_product_types
  end

  def update_type_introduction
    introduction_1_array = params[:introduction_1].split('|')
    introduction_2_array = params[:introduction_2].split('|')
    introduction_1 = AttributesTranslationHistory.create(china: introduction_1_array[0].try(:strip),
                                                          america: introduction_1_array[1].try(:strip),
                                                          canada: introduction_1_array[2].try(:strip),
                                                          british: introduction_1_array[3].try(:strip),
                                                          germany: introduction_1_array[4].try(:strip),
                                                          france: introduction_1_array[5].try(:strip),
                                                          spain: introduction_1_array[6].try(:strip),
                                                          italy: introduction_1_array[7].try(:strip))
    introduction_2 = AttributesTranslationHistory.create(china: introduction_2_array[0].try(:strip),
                                                          america: introduction_2_array[1].try(:strip),
                                                          canada: introduction_2_array[2].try(:strip),
                                                          british: introduction_2_array[3].try(:strip),
                                                          germany: introduction_2_array[4].try(:strip),
                                                          france: introduction_2_array[5].try(:strip),
                                                          spain: introduction_2_array[6].try(:strip),
                                                          italy: introduction_2_array[7].try(:strip))
    ProductType.find(params[:id]).update_attributes(product_type_introduction_1: introduction_1.id, product_type_introduction_2: introduction_2.id)
    render json:true
  end

  def update_type_setting
    type_setting_values = params[:type_values].split('|')
    feed_attribute_values, type1_attribute_values, type2_attribute_values = type_setting_values[0..7], type_setting_values[8..15], type_setting_values[16..23]

    if feed_attribute_values.present?
      attribute_feed = AttributesTranslationHistory.create(china: feed_attribute_values[0],
                                                          america: feed_attribute_values[1],
                                                          canada: feed_attribute_values[2],
                                                          british: feed_attribute_values[3],
                                                          germany: feed_attribute_values[4],
                                                          france: feed_attribute_values[5],
                                                          spain: feed_attribute_values[6],
                                                          italy: feed_attribute_values[7])
    end

    if type1_attribute_values.present?
      attribute_type1 = AttributesTranslationHistory.create(china: type1_attribute_values[0],
                                                          america: type1_attribute_values[1],
                                                          canada: type1_attribute_values[2],
                                                          british: type1_attribute_values[3],
                                                          germany: type1_attribute_values[4],
                                                          france: type1_attribute_values[5],
                                                          spain: type1_attribute_values[6],
                                                          italy: type1_attribute_values[7])
    end

    if type2_attribute_values.present?
      attribute_type2 = AttributesTranslationHistory.create(china: type2_attribute_values[0],
                                                          america: type2_attribute_values[1],
                                                          canada: type2_attribute_values[2],
                                                          british: type2_attribute_values[3],
                                                          germany: type2_attribute_values[4],
                                                          france: type2_attribute_values[5],
                                                          spain: type2_attribute_values[6],
                                                          italy: type2_attribute_values[7])
    end

    update_hash = {}
    update_hash[:product_type_feed] = attribute_feed.id if attribute_feed.present?
    update_hash[:product_type_1] = attribute_type1.id if attribute_type1.present?
    update_hash[:product_type_2] = attribute_type2.id if attribute_type2.present?

    ProductType.find(params[:id]).update_attributes(update_hash)
  end

  def update_description
    attribute_translation = AttributesTranslationHistory.create(china: params[:descriptionTextArea0],
                                                          america: params[:descriptionTextArea1],
                                                          canada: params[:descriptionTextArea2],
                                                          british: params[:descriptionTextArea3],
                                                          germany: params[:descriptionTextArea4],
                                                          france: params[:descriptionTextArea5],
                                                          spain: params[:descriptionTextArea6],
                                                          italy: params[:descriptionTextArea7])
    ProductType.find(params[:id]).update_attributes(product_type_description: attribute_translation.id)
  end

  def update_price_setting
    price_values_array = params[:price_value].split('|')
    attribute_translation = AttributesTranslationHistory.create(china: price_values_array[0],
                                                          america: price_values_array[1],
                                                          canada: price_values_array[2],
                                                          british: price_values_array[3],
                                                          germany: price_values_array[4],
                                                          france: price_values_array[5],
                                                          spain: price_values_array[6],
                                                          italy: price_values_array[7])
    ProductType.find(params[:id]).update_attributes(price_translation: attribute_translation.id)
  end
  
  def update_product_type_attribute
    attributes_value_array = params[:attributes_value].split('|')
    product_attribute_is_locked = true
    # product_attribute_is_locked = attributes_value_array[1] == 'true' ? true : false
    if params[:attribute_id].present?
      product_attribute = ProductAttribute.find(params[:attribute_id])
      product_attribute.update_attributes(attribute_name: attributes_value_array[0], is_locked: product_attribute_is_locked, table_name: attributes_value_array[2], product_type_id: params[:id])
      # product_attribute.attributes_translation_histories.first.update_attributes(attribute_name: attributes_value_array[0], china: attributes_value_array[3], america: attributes_value_array[4], canada: attributes_value_array[5], british: attributes_value_array[6], germany: attributes_value_array[7], spain: attributes_value_array[9], italy: attributes_value_array[10], france: attributes_value_array[8])
      AttributesTranslationHistory.find(params[:attribute_history_id]).update_attributes(attribute_name: attributes_value_array[0], china: attributes_value_array[3], america: attributes_value_array[4], canada: attributes_value_array[5], british: attributes_value_array[6], germany: attributes_value_array[7], spain: attributes_value_array[9], italy: attributes_value_array[10], france: attributes_value_array[8])
    else
      product_attribute = ProductAttribute.where(attribute_name: attributes_value_array[0], product_type_id: @product_type.id).first
      product_attribute = ProductAttribute.create(attribute_name: attributes_value_array[0], is_locked: product_attribute_is_locked, table_name: attributes_value_array[2], product_type_id: params[:id]) unless product_attribute.present?
      AttributesTranslationHistory.create(attribute_name: attributes_value_array[0], china: attributes_value_array[3], america: attributes_value_array[4], canada: attributes_value_array[5], british: attributes_value_array[6], germany: attributes_value_array[7], spain: attributes_value_array[9], italy: attributes_value_array[10], france: attributes_value_array[8], product_attribute_id: product_attribute.id)
    end
    @product_type_attributes = @product_type.product_attributes
  end

  def update_shipment_method
    # shipment_method_china = ShipmentMethod.find(params[:shipment_method_china])
    shipment_method_america = ShipmentMethod.find(params[:shipment_method_america])
    shipment_method_canada = ShipmentMethod.find(params[:shipment_method_canada])
    shipment_method_british = ShipmentMethod.find(params[:shipment_method_british])
    shipment_method_germany = ShipmentMethod.find(params[:shipment_method_germany])
    shipment_method_france = ShipmentMethod.find(params[:shipment_method_france])
    shipment_method_spain = ShipmentMethod.find(params[:shipment_method_spain])
    shipment_method_italy = ShipmentMethod.find(params[:shipment_method_italy])

    attribute_translation = AttributesTranslationHistory.create(america: shipment_method_america.id,
                                                                canada: shipment_method_canada.id,
                                                                british: shipment_method_british.id,
                                                                germany: shipment_method_germany.id,
                                                                france: shipment_method_france.id,
                                                                spain: shipment_method_spain.id,
                                                                italy: shipment_method_italy.id)
    # ProductType.find(params[:id]).update_attributes(shipment_translation: attribute_translation.id)
    if params[:shipment_weight_relatioin_id].present?
      ShipmentWeightRelation.find(params[:shipment_weight_relatioin_id]).update_attributes(min_weight: params[:min_weight], max_weight: params[:max_weight], product_type_id: params[:id], attributes_translation_history_id: attribute_translation.id)
    else
      @new_relation = ShipmentWeightRelation.create(min_weight: params[:min_weight], max_weight: params[:max_weight], product_type_id: params[:id], attributes_translation_history_id: attribute_translation.id)
    end
    if @new_relation
      render json: @new_relation.id
    end
  end

  def index
    @product_type_father_node = params[:father_node] || '0'
    @product_types = ProductType.where(father_node: @product_type_father_node)
  end

  def show
  end

  def new
    @product_type = ProductType.new
  end

  def remove_shipment_relation
    ShipmentWeightRelation.delete(params[:shipment_relation_id])
    render json: true
  end

  def edit
    @shipment_methods = ShipmentMethod.all
    @product_type_attributes = @product_type.product_attributes
    @product_shipments = @product_type.shipment_weight_relations
  end

  def create
    if ProductType.where(name: params[:product_type_name], father_node: params[:father_node]).count > 0
      @flag = false
    else
      @flag = true
      ProductType.create(name: params[:product_type_name], father_node: params[:father_node])
      @product_types = ProductType.where(father_node: params[:father_node])
      @product_type_father_node = params[:father_node] || '0'
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
    if @product_type.is_final_type
      @product_type.destroy
    else
      render json: 1
    end
    # respond_to do |format|
    #   format.html { redirect_to product_types_url, notice: 'Product type was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  def remove_product_type_attribute
    product_attribute = ProductAttribute.find(params[:id])
    attribute_translation = AttributesTranslationHistory.find(params[:attribute_translation_id])
    if attribute_translation
      attribute_translation.destroy
    end
    if product_attribute.attributes_translation_histories.count == 0
      product_attribute.destroy
    end
    @product_type_attributes = product_attribute.product_type.product_attributes
  end

  private
    def set_product_type
      @product_type = ProductType.find(params[:id])
    end

    def product_type_params
      params.require(:product_type).permit(:name, :father_node, :deleted_at)
    end
end
