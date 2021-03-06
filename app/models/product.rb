class Product < ActiveRecord::Base
  belongs_to :product_type
  belongs_to :user
  belongs_to :shop

  has_many :variables, dependent: :delete_all
  has_many :product_customize_attributes_relations

  accepts_nested_attributes_for :variables

  has_many :product_info_translations
  has_many :product_basic_infos, dependent: :nullify

  # **********************
  # * shield_type: 1 shield; 2, pre_saled; 3, temp_offsale; 4, wait for edited;
  # * auto_flag:  11, auto online; 12, auto offline; 13, auto destroy; 14, auto from offline to onlie
  # *
  # *
  # *
  # *
  # *
  # *
  # *
  # **********************

  scope :un_updated, -> {where(update_status:false)}
  scope :updated, -> {where(update_status:true)}
  scope :un_shield, -> {where(shield_type: 0)}
  scope :shield, -> {where(shield_type: 1)}
  scope :edited, -> {where(shield_type: 4)}
  scope :onsale, -> {where(on_sale: true)}
  scope :offsale, -> {where(on_sale: false).un_shield}
  scope :temp_offsale, -> {where(shield_type: 3).where(on_sale:false)}
  # scope :pre_saled, -> {where.not(presale_date: nil).where(shield_type:2).where(on_sale:false)}
  scope :pre_saled, -> {where(shield_type:2).where(on_sale:false)}
  scope :auto_stand_by, -> {where(auto_flag: 14)}
  scope :auto_removed, -> {where(auto_flag: 13)}
  # scope :not_off_sale, ->{where(on_sale:true)}

  before_create :save_sku

  mount_uploader :avatar, AvatarUploader
  mount_uploader :avatar1, AvatarUploader
  mount_uploader :avatar2, AvatarUploader

  def set_stock_zero?
    self.on_sale == 0 || self.shield_type == '1' || self.auto_flag == '14' || self.auto_flag == '13'
  end

  def is_translated?
    self.translate_status
  end

  def get_shipment_cost language, weight=nil
    shipment_relations = self.product_type.shipment_weight_relations
    weight = self.product_weight if weight.nil?
    shipment_relation = shipment_relations.where("(min_weight < ? or min_weight = ?) and (max_weight > ? or max_weight = ?) ", weight, weight, weight, weight).last
    if shipment_relation.present?
      shipment_method_id = shipment_relation.attributes_translation_history.read_attribute(language)
      if shipment_method_id
        all_shipment_method_values = ShipmentMethod.find(shipment_method_id).shipment_method_values
        shipment_method = all_shipment_method_values.where("weight > ?", weight.to_f).first
        shipment_method = all_shipment_method_values.order("weight").last unless shipment_method.present?
        if shipment_method.present?
          shipment_method.read_attribute("#{language}_price").to_f
        else
          100.0
        end
      end
    else
      100.0
    end
  end

  def valid_images
  	image_names = []
  	1.upto(30) do |t|
  		image_names << "images#{t}"
  	end

  	@valid_images = []
  	image_names.each do |attr|
  		@valid_images << self.read_attribute("#{attr}") unless self.read_attribute("#{attr}").blank?
  	end
  	@valid_images
  end

  def self.unescape(string)
    String.class_eval(%Q("#{string}"))
  end

  def self.export_format_string string
    string.strip.gsub('，', ',').gsub('。', '.').gsub("\r", '').gsub("：",':').gsub(" ", ' ') if string.present?
  end

  def self.choose_language(language, product)
    local_infos = {}
    product_translation = product.product_info_translations.last
    case language
    when 'british'
      local_infos[:title] = Product.export_format_string(product_translation.try(:e_t))
      local_infos[:detail] = Product.export_format_string(product_translation.try(:e_detail))
      local_infos[:des1] = Product.export_format_string(product_translation.try(:e_des1))
      local_infos[:des2] = Product.export_format_string(product_translation.try(:e_des2))
      local_infos[:des3] = Product.export_format_string(product_translation.try(:e_des3))
    when 'germany'
      local_infos[:title] = Product.export_format_string(product_translation.try(:g_t))
      local_infos[:detail] = Product.export_format_string(product_translation.try(:g_detail))
      local_infos[:des1] = Product.export_format_string(product_translation.try(:g_des1))
      local_infos[:des2] = Product.export_format_string(product_translation.try(:g_des2))
      local_infos[:des3] = Product.export_format_string(product_translation.try(:g_des3))
    when 'france'
      local_infos[:title] = Product.export_format_string(product_translation.try(:f_t))
      local_infos[:detail] = Product.export_format_string(product_translation.try(:f_detail))
      local_infos[:des1] = Product.export_format_string(product_translation.try(:f_des1))
      local_infos[:des2] = Product.export_format_string(product_translation.try(:f_des2))
      local_infos[:des3] = Product.export_format_string(product_translation.try(:f_des3))
    when 'spain'
      local_infos[:title] = Product.export_format_string(product_translation.try(:s_t))
      local_infos[:detail] = Product.export_format_string(product_translation.try(:s_detail))
      local_infos[:des1] = Product.export_format_string(product_translation.try(:s_des1))
      local_infos[:des2] = Product.export_format_string(product_translation.try(:s_des2))
      local_infos[:des3] = Product.export_format_string(product_translation.try(:s_des3))
    when 'italy'
      local_infos[:title] = Product.export_format_string(product_translation.try(:i_t))
      local_infos[:detail] = Product.export_format_string(product_translation.try(:i_detail))
      local_infos[:des1] = Product.export_format_string(product_translation.try(:i_des1))
      local_infos[:des2] = Product.export_format_string(product_translation.try(:i_des2))
      local_infos[:des3] = Product.export_format_string(product_translation.try(:i_des3))
    when 'america'
      local_infos[:title] = Product.export_format_string(product_translation.try(:e_t))
      local_infos[:detail] = Product.export_format_string(product_translation.try(:e_detail))
      local_infos[:des1] = Product.export_format_string(product_translation.try(:e_des1))
      local_infos[:des2] = Product.export_format_string(product_translation.try(:e_des2))
      local_infos[:des3] = Product.export_format_string(product_translation.try(:e_des3))
    when 'canada'
      local_infos[:title] = Product.export_format_string(product_translation.try(:e_t))
      local_infos[:detail] = Product.export_format_string(product_translation.try(:e_detail))
      local_infos[:des1] = Product.export_format_string(product_translation.try(:e_des1))
      local_infos[:des2] = Product.export_format_string(product_translation.try(:e_des2))
      local_infos[:des3] = Product.export_format_string(product_translation.try(:e_des3))
    else
      local_infos[:title] = Product.export_format_string(product.title)
      local_infos[:detail] = Product.export_format_string(product.details)
      local_infos[:des1] = Product.export_format_string(product.product_intro_1)
      local_infos[:des2] = Product.export_format_string(product.product_intro_2)
      local_infos[:des3] = Product.export_format_string(product.product_intro_3)
    end
    local_infos
  end

  def self.get_all_customize_columns products
    all_product_types = products.map {|product| product.product_type }.compact.uniq
    all_product_types.map do |product_type|
      product_type.product_attributes.map do |attribute|
        attribute.attribute_name
      end
    end.flatten.uniq
  end

  def self.get_all_customize_table_columns products
    all_product_types = products.map {|product| product.product_type }.compact.uniq
    all_product_types.map do |product_type|
      product_type.product_attributes.map do |attribute|
        attribute.table_name
      end
    end.flatten.uniq
  end

  def get_profit_rate language
    product_type = self.product_type
    price_translation = product_type.price_translation
    if price_translation.present?
      profit_rate = AttributesTranslationHistory.find(price_translation).read_attribute(language).to_f
      if profit_rate.present?
        profit_rate = profit_rate
      else
        profit_rate = 2.0
      end
    end
    profit_rate = 1.5 if profit_rate.nil? || profit_rate < 1.5
    profit_rate
  end

  # def self.to_txt options={}
  #   system("mkdir 'hello'")
  #   file = File.new("hello/1.rb", 'a+')
  #   file.puts("a\tb\tc")
  #   file.puts("1\t2\t3")
  #   file.close
  #   file = File.new("hello/2.rb", 'a+')
  #   file.puts("a2\tb2\tc2")
  #   file.puts("11\t22\t33")
  #   file.close
  #   # system(" wget -r -np -nH --cut-dirs=3 -R index.html file://Users/Leo/work/rails/projects/amazon_tmall/hello ")
  #   # xls_column_names = %w(a b c)
  #   # CSV.generate(options) do |csv|
  #   #   csv << xls_column_names
  #   #   csv << ['a1', 'b1', 'c1']
  #   #   csv << ['end']
  #   # end
  # end

  def self.to_csv(language, max_limit, options={})
    cash_rate = CashRate.last.try(language.to_sym).to_f
    # Custome the xls columns and languages
    xls_column_names = %w(item_sku item_name external_product_id external_product_id_type feed_product_type brand_name manufacture
                          part_number product_description update_delete standard_price currency condition_type condition_note quantity
                          website_shipping_weight website_shipping_weight_unit_of_measure bullet_point1 bullet_point2 bullet_point3
                          bullet_point4 bullet_point5 recommended_browse_nodes1 recommended_browse_nodes2 generic_keywords1 generic_keywords12
                          generic_keywords13 generic_keywords14 generic_keywords15 main_image_url other_image_url1
                          other_image_url2 other_image_url3 other_image_url4 other_image_url5 other_image_url6 other_image_url7
                          other_image_url8 parent_child parent_sku relationship_type variation_theme color_name color_map size_name size_map)
    cusomize_column_names = Product.get_all_customize_columns self.all
    cusomize_table_names = Product.get_all_customize_table_columns self.all
    xls_column_names = xls_column_names + cusomize_table_names

    country_currency = {british:'GBP', germany:'EUR', france: 'EUR', spain:'EUR', italy:'EUR', china:'人民币', america:'USD', canada:'CAD'}
    country_sku = {british: 'UK', germany:'DE', france:'FR', spain:'ES', italy:'IT', america:'US', canada:'CA'}
    variable_hash = {british: 'en', germany:'de', france:'fr', spain:'es', italy:'it', america:'en', canada:'en'}
    max_limit = 9999999 unless max_limit.present?
    csv_line_count = 0

    CSV.generate(options) do |csv|
      csv << xls_column_names
      # csv_line_count ＝ csv_line_count ＋ 1
      all.un_shield.updated.each do |product|
        puts "#{product.id} | csv_line_count #{csv_line_count} "
        break if max_limit.to_i < (csv_line_count + product.variables.count + 1)
        # Customize the xls values
        # csv << ['product.attributes.values_at(*column_names)', 'hello', 'world']
        # 父产品
        xls_column_values = []
        # item_sku
        xls_column_values << product.sku[0..35].lstrip
        product_translation = Product.choose_language(language, product)
        # item_name
        xls_column_values << product_translation[:title]
        # external_product_id
        xls_column_values << ""
        # external_product_id_type
        if product.variables.count < 1
          xls_column_values << "UPC"
        else
          xls_column_values << ""
        end
        # feed_product_type
        if product.product_type.present? && product.product_type.product_type_feed.present?
          product_type_translation = AttributesTranslationHistory.find(product.product_type.product_type_feed)
          xls_column_values << product_type_translation.read_attribute(language)
        else
          xls_column_values << ''
        end
        # brand_name
        if product.product_type.present? && product.product_type.product_type_name_translation.present?
          product_brand_name = AttributesTranslationHistory.find(product.product_type.product_type_name_translation)
          product_brand_name_translation = product_brand_name.read_attribute(language)
        else
          product_brand_name_translation = ''
        end
        xls_column_values << product_brand_name_translation
        # manufacture
        if product.shop.present?
          product_manufacture = product.shop.manufacture
        else
          product_manufacture = product_brand_name_translation
        end
        xls_column_values << product_manufacture
        # part_number
        xls_column_values << ('a'..'z').to_a.sample(5).join
        # product_description
        if product.product_type.product_type_description.present?
          product_type_description_content = AttributesTranslationHistory.find(product.product_type.product_type_description).read_attribute(language)
        else
          product_type_description_content = ''
        end

        product_translation_detail = product_translation[:detail]
        if product_translation_detail.present?
          product_translation_detail = product_translation_detail + product_type_description_content if product_type_description_content.present?
        else
          product_translation_detail = product_type_description_content if product_type_description_content.present?
        end

        xls_column_values << product_translation_detail
        # update_delete
        xls_column_values << 'Update'
        # standard_price
        shipment_cost = product.get_shipment_cost(language)
        profit_rate = product.get_profit_rate language
        xls_column_values << (1 + ((shipment_cost + product.try(:price).try(:to_f)) * profit_rate / cash_rate).to_i).to_i
        # currency
        xls_column_values << country_currency[language.to_sym]
        # condition_type
        xls_column_values << 'New'
        # condition_note
        if product.product_type.product_type_introduction_1.present?
          product_type_introduction1 = AttributesTranslationHistory.find(product.product_type.product_type_introduction_1)
          xls_column_values << product_type_introduction1.read_attribute(language)
        else
          product_type_introduction1 = ''
          xls_column_values << product_type_introduction1
        end
        # quantity
        quantity = product.variables.present? ? '' : product.stock
        xls_column_values << quantity
        # website_shipping_weight
        xls_column_values << product.product_weight
        xls_column_values << 'KG'
        # bullet_points
        xls_column_values << product_translation[:des1]
        xls_column_values << product_translation[:des2]
        xls_column_values << product_translation[:des3]
        if product_type_introduction1.present?
          xls_column_values << product_type_introduction1.read_attribute(language)
        else
          xls_column_values << ''
        end
        product_type_introduction_2_id = product.product_type.product_type_introduction_2
        if product_type_introduction_2_id.present?
          product_type_introduction_2_id_translation = AttributesTranslationHistory.find(product_type_introduction_2_id)
          if product_type_introduction_2_id_translation.present?
            product_type_introduction2 = product_type_introduction_2_id_translation.read_attribute(language)
            xls_column_values << product_type_introduction2
          end
        else
          xls_column_values << ''
        end

        # recommended_browse_nodes
        product_type_1_id = product.product_type.product_type_1
        if product_type_1_id.present?
          product_type_1_id_translation = AttributesTranslationHistory.find(product_type_1_id)
          if product_type_1_id_translation.present?
            product_type1 = product_type_1_id_translation.read_attribute(language)
            xls_column_values << product_type1
          end
        else
          xls_column_values << ''
        end

        product_type_2_id = product.product_type.product_type_2
        if product_type_2_id.present?
          product_type_2_id_translation = AttributesTranslationHistory.find(product.product_type.product_type_2)
          if product_type_2_id_translation.present?
            product_type2 = product_type_2_id_translation.read_attribute(language)
            xls_column_values << product_type2
          end
        else
          xls_column_values << ''
        end

        # generic_keywords
        key_word1_translation_id = product.product_type.key_word1_translation
        if key_word1_translation_id.present?
          key_word1_translation_id_translation = AttributesTranslationHistory.find(key_word1_translation_id)
          if key_word1_translation_id_translation.present?
            key_word1 = key_word1_translation_id_translation.read_attribute(language)
            xls_column_values << key_word1
          end
        else
          xls_column_values << ''
        end

        key_word2_translation_id = product.product_type.key_word2_translation
        if key_word2_translation_id.present?
          key_word2_translation_id_translation = AttributesTranslationHistory.find(key_word2_translation_id)
          if key_word2_translation_id_translation.present?
            key_word2 = key_word2_translation_id_translation.read_attribute(language)
            xls_column_values << key_word2
          end
        else
          xls_column_values << ''
        end

        key_word3_translation_id = product.product_type.key_word3_translation
        if key_word3_translation_id.present?
          key_word3_translation_id_translation = AttributesTranslationHistory.find(key_word3_translation_id)
          if key_word3_translation_id_translation.present?
            key_word3 = key_word3_translation_id_translation.read_attribute(language)
            xls_column_values << key_word3
          end
        else
          xls_column_values << ''
        end

        key_word4_translation_id = product.product_type.key_word4_translation
        if key_word4_translation_id.present?
          key_word4_translation_id_translation = AttributesTranslationHistory.find(key_word4_translation_id)
          if key_word4_translation_id_translation.present?
            key_word4 = key_word4_translation_id_translation.read_attribute(language)
            xls_column_values << key_word4
          end
        else
          xls_column_values << ''
        end

        key_word5_translation_id = product.product_type.key_word5_translation
        if key_word5_translation_id.present?
          key_word5_translation_id_translation = AttributesTranslationHistory.find(key_word5_translation_id)
          if key_word5_translation_id_translation.present?
            key_word5 = key_word5_translation_id_translation.read_attribute(language)
            xls_column_values << key_word5
          end
        else
          xls_column_values << ''
        end

        # if product.product_type.key_word2_translation.present? && AttributesTranslationHistory.find(product.product_type.key_word2_translation).present?
        #   key_word = AttributesTranslationHistory.find(product.product_type.key_word2_translation)
        #   xls_column_values << key_word.read_attribute(language)
        # else
        #   xls_column_values << ''
        # end

        # if product.product_type.key_word3_translation.present? && AttributesTranslationHistory.find(product.product_type.key_word3_translation).present?
        #   key_word = AttributesTranslationHistory.find(product.product_type.key_word3_translation)
        #   xls_column_values << key_word.read_attribute(language)
        # else
        #   xls_column_values << ''
        # end

        # if product.product_type.key_word4_translation.present? && AttributesTranslationHistory.find(product.product_type.key_word4_translation).present?
        #   key_word = AttributesTranslationHistory.find(product.product_type.key_word4_translation)
        #   xls_column_values << key_word.read_attribute(language)
        # else
        #   xls_column_values << ''
        # end

        # if product.product_type.key_word5_translation.present? && AttributesTranslationHistory.find(product.product_type.key_word5_translation).present?
        #   key_word = AttributesTranslationHistory.find(product.product_type.key_word5_translation)
        #   xls_column_values << key_word.read_attribute(language)
        # else
        #   xls_column_values << ''
        # end

        # if product.image_url
        images_url = [product.images1, product.images2, product.images3, product.images4, product.images5, product.images6,
                     product.images7, product.images8, product.images9, product.images10, product.avatar_img_url,
                     product.avatar_img_url1, product.avatar_img_url2]
        images_url.each_with_index do |url,index|
          i_index = 0
          until images_url[i_index].blank?
            i_index = i_index + 1
          end
          if i_index < index
            images_url[i_index] = images_url[index]
            images_url[index] = ''
          end
        end
        xls_column_values << images_url[0]
        # else
          # xls_column_values << ""
        # end
        xls_column_values << images_url[1]
        xls_column_values << images_url[2]
        xls_column_values << images_url[3]
        xls_column_values << images_url[4]
        xls_column_values << images_url[5]
        xls_column_values << images_url[6]
        xls_column_values << images_url[7]
        xls_column_values << images_url[8]

        # parent_child
        if product.variables.count < 1
          xls_column_values << "Child"
        else
          xls_column_values << "Parent"
        end
        # parent_sku
        xls_column_values << ""
        # relationship_type
        xls_column_values << ""
        # variation_theme
        variation_theme = ""
        unless product.try(:variables).try(:first).try(:color).blank?
          variation_theme << 'Color'
        end
        unless product.try(:variables).try(:first).try(:size).blank?
          variation_theme << 'Size'
        end      
        xls_column_values << variation_theme
        # color_name
        xls_column_values << ""
        # color_map
        xls_column_values << ""
        # size_name
        xls_column_values << ""
        # size_map
        xls_column_values << ""

        # customize_columns
        cusomize_column_names.each do |column_name|
          customize_relation = product.product_customize_attributes_relations.where(attribute_name: column_name).first
          if customize_relation.present? && customize_relation.attributes_translation_history.present?
            xls_column_values << customize_relation.attributes_translation_history.read_attribute(language)
          else
            xls_column_values << ''
          end
        end

        csv << xls_column_values
        csv_line_count = csv_line_count + 1

        # 子产品
        product.variables.each do |v|
          xls_column_values = []
          v_color = ''
          v_size = ''
          v_variable_info_translation = v
          if v.color.present? && v.size.present?
            v_color = VariableTranslateHistory.where(word: v.color, variable_from:'color').first
            v_size = VariableTranslateHistory.where(word: v.size, variable_from:'size').first
            xls_column_values << "#{product.sku}-#{v_color.try(:en)}#{v_size.try(:en)}"[0..35].lstrip
          elsif v.color.present?
            if v_variable_info_translation
              v_color = VariableTranslateHistory.where(word: v.color, variable_from:'color').first
              v_size = ""
              xls_column_values << "#{product.sku}-#{v_color.try(:en)}"[0..35].lstrip
            else
              xls_column_values << "这个变体没有翻译，请重新翻译"  
            end
          elsif v.size.present?
            if v_variable_info_translation
              v_size = VariableTranslateHistory.where(word: v.size, variable_from:'size').first
              xls_column_values << "#{product.sku}-#{v_size.try(:en)}"[0..35].lstrip
            else
              xls_column_values << "这个变体没有翻译，请重新翻译"  
            end
          end
          
          if v.color.present? && v.size.present? && v_color.present? && v_size.present?
            xls_column_values << "#{product_translation[:title]}-#{v_color.read_attribute(variable_hash[language.to_sym])} #{v_size.read_attribute(variable_hash[language.to_sym])}"
          elsif v.color.present? && v_color.present?
            xls_column_values << "#{product_translation[:title]}-#{v_color.read_attribute(variable_hash[language.to_sym])}"
          elsif v.size.present? && v_size.present?
            xls_column_values << "#{product_translation[:title]}-#{v_size.read_attribute(variable_hash[language.to_sym])}"
          else
            xls_column_values << "#{product_translation[:title]}"
          end

          xls_column_values << ""

          xls_column_values << "UPC"
          # feed_product_type
          if product_type_translation.present?
            xls_column_values << product_type_translation.read_attribute(language)
          else
            xls_column_values << ''
          end
          # brand_name
          xls_column_values << product_brand_name_translation
          # manufacture
          xls_column_values << product_manufacture
          # part_number
          xls_column_values << ('a'..'z').to_a.sample(5).join
          # product_description
          xls_column_values << product_translation_detail

          xls_column_values << 'Update'
          # standard_price
          if v.try(:price).present?
            if v.weight.present?
              shipment_cost = product.get_shipment_cost(language, v.weight)
            end
            xls_column_values << (1 + ((shipment_cost + v.try(:price).try(:to_f)) * profit_rate / cash_rate).to_i ).to_i
          else
            xls_column_values << (1 + ((shipment_cost + product.try(:price).try(:to_f)) * profit_rate / cash_rate).to_i ).to_i
          end
          # currency
          xls_column_values << country_currency[language.to_sym]
          xls_column_values << 'New'
          # condition_note
          if product_type_introduction1.present?
            xls_column_values << product_type_introduction1.read_attribute(language)
          else
            xls_column_values << ''
          end
          # quantity
          if product.set_stock_zero?
            xls_column_values << 0
          else
            if v.stock.to_i > 100
              xls_column_values << 100
            elsif v.stock.to_i <= 2
              xls_column_values << 0
            else
              xls_column_values << v.stock
            end
          end
          # website_shipping_weight
          if v.weight.present?
            xls_column_values << v.weight
          else
            xls_column_values << product.product_weight
          end
          xls_column_values << 'KG'
          # bullet_points
          xls_column_values << product_translation[:des1]
          xls_column_values << product_translation[:des2]

          if v.desc.present?
              xls_column_values << v.read_attribute("#{variable_hash[language.to_sym]}")
          else
            xls_column_values << product_translation[:des3]
          end

          if product_type_introduction1.present?
            xls_column_values << product_type_introduction1.read_attribute(language)
          else
            xls_column_values << ''
          end

          if product_type_introduction_2_id.present? && product_type_introduction_2_id_translation.present?
            # product_type_introduction2 = AttributesTranslationHistory.find(product.product_type.product_type_introduction_2)
            xls_column_values << product_type_introduction2
          else
            xls_column_values << ''
          end
          # recommended_browse_nodes
          if product_type_1_id.present? && product_type_1_id_translation.present?
            # product_type1 = AttributesTranslationHistory.find(product.product_type.product_type_1)
            xls_column_values << product_type1
          else
            xls_column_values << ''
          end

          if product_type_2_id.present? && product_type_2_id_translation.present?
            # product_type2 = product_type_2_id_translation.read_attribute(language)
            xls_column_values << product_type2
          else
            xls_column_values << ''
          end

          # generic_keywords
          key_word1_translation_id = product.product_type.key_word1_translation
          if key_word1_translation_id.present? && key_word1_translation_id_translation.present?
            # key_word = AttributesTranslationHistory.find(product.product_type.key_word1_translation)
            xls_column_values << key_word1
          else
            xls_column_values << ''
          end
          key_word2_translation_id = product.product_type.key_word2_translation
          if key_word2_translation_id.present? && key_word2_translation_id_translation.present?
            # key_word = AttributesTranslationHistory.find(product.product_type.key_word2_translation)
            xls_column_values << key_word2
          else
            xls_column_values << ''
          end
          key_word3_translation_id = product.product_type.key_word3_translation
          if key_word3_translation_id.present? && key_word3_translation_id_translation.present?
            # key_word = AttributesTranslationHistory.find(product.product_type.key_word3_translation)
            xls_column_values << key_word3
          else
            xls_column_values << ''
          end
          key_word4_translation_id = product.product_type.key_word4_translation
          if key_word4_translation_id.present? && key_word4_translation_id_translation.present?
            # key_word = AttributesTranslationHistory.find(product.product_type.key_word4_translation)
            xls_column_values << key_word4
          else
            xls_column_values << ''
          end
          key_word5_translation_id = product.product_type.key_word5_translation
          if key_word5_translation_id.present? && key_word5_translation_id_translation.present?
            # key_word = AttributesTranslationHistory.find(product.product_type.key_word5_translation)
            xls_column_values << key_word5
          else
            xls_column_values << ''
          end

          # if product.product_type.key_word2_translation.present? && AttributesTranslationHistory.find(product.product_type.key_word2_translation).present?
          #   key_word = AttributesTranslationHistory.find(product.product_type.key_word2_translation)
          #   xls_column_values << key_word.read_attribute(language)
          # else
          #   xls_column_values << ''
          # end

          # if product.product_type.key_word3_translation.present? && AttributesTranslationHistory.find(product.product_type.key_word3_translation).present?
          #   key_word = AttributesTranslationHistory.find(product.product_type.key_word3_translation)
          #   xls_column_values << key_word.read_attribute(language)
          # else
          #   xls_column_values << ''
          # end

          # if product.product_type.key_word4_translation.present? && AttributesTranslationHistory.find(product.product_type.key_word4_translation).present?
          #   key_word = AttributesTranslationHistory.find(product.product_type.key_word4_translation)
          #   xls_column_values << key_word.read_attribute(language)
          # else
          #   xls_column_values << ''
          # end

          # if product.product_type.key_word5_translation.present? && AttributesTranslationHistory.find(product.product_type.key_word5_translation).present?
          #   key_word = AttributesTranslationHistory.find(product.product_type.key_word5_translation)
          #   xls_column_values << key_word.read_attribute(language)
          # else
          #   xls_column_values << ''
          # end

          v_images_url = [v.image_url1,  v.image_url2,  v.image_url3,  v.image_url4,  v.image_url5,  v.image_url6,  v.image_url7,  v.image_url8,  v.image_url9,  v.image_url10,
                          v.image_url11, v.image_url12, v.image_url13, v.image_url14, v.image_url15, v.image_url16, v.image_url17, v.image_url18, v.image_url19, v.image_url20,
                          v.image_url21, v.image_url22, v.image_url23, v.image_url24, v.image_url25, v.image_url26, v.image_url27, v.image_url28, v.image_url29, v.image_url30,
                          product.avatar_img_url, product.avatar_img_url1, product.avatar_img_url2]
          v_images_url.each_with_index do |url,index|
            i_index = 0
            until v_images_url[i_index].blank?
              i_index = i_index + 1
            end
            if i_index < index
              v_images_url[i_index] = v_images_url[index]
              v_images_url[index] = ''
            end
          end
          xls_column_values << v_images_url[0]
          xls_column_values << v_images_url[1]
          xls_column_values << v_images_url[2]
          xls_column_values << v_images_url[3]
          xls_column_values << v_images_url[4]
          xls_column_values << v_images_url[5]
          xls_column_values << v_images_url[6]
          xls_column_values << v_images_url[7]
          xls_column_values << v_images_url[8]

          xls_column_values << "Child"
          xls_column_values << product.sku
          xls_column_values << "Variation"
          xls_column_values << variation_theme

          if v_color.present?
            xls_column_values << v_color.read_attribute(variable_hash[language.to_sym])
            xls_column_values << v_color.read_attribute(variable_hash[language.to_sym])
          else
            xls_column_values << ""
            xls_column_values << ""
          end

          if v_size.present?
            xls_column_values << v_size.read_attribute(variable_hash[language.to_sym])
            xls_column_values << v_size.read_attribute(variable_hash[language.to_sym])
          else
            xls_column_values << ""
            xls_column_values << ""
         end
          # customize_columns
          cusomize_column_names.each do |column_name|
            customize_relation = product.product_customize_attributes_relations.where(attribute_name: column_name).first
            if customize_relation && customize_relation.attributes_translation_history.present?
              xls_column_values << customize_relation.attributes_translation_history.read_attribute(language)
            else
              xls_column_values << ''
            end
          end
          csv << xls_column_values
          csv_line_count = csv_line_count + 1
        end
      end

    end
  end


  # def self.defaul_to_csv(language, options={})
  #   cash_rate = CashRate.last.try(language.to_sym).to_f
  #   # Custome the xls columns and languages
  #   xls_column_names = ["item_sku","external_product_id", "external_product_type","item_name", "brand_name",
  #                       "standard_price", "Currency", "Stock", "Heel_height", "Seasons",
  #                       "main_image_url", "switch_image_url", "other_image_url1", "other_image_url2",
  #                       "other_image_url3", "other_image_url4","other_image_url5", "other_image_url6",
  #                       "other_image_url7", "other_image_url8", "parent_child", "parent_sku", "relationship_type",
  #                       "variation_theme", "color_name", "color_map", "size_name", "size_map", "Details",
  #                       "Outer_material_type", "Inner_material_type", "Sole_material", "Closure_type", "Heel_type"]

  #   country_currency = {british:'GBP', germany:'EUR', france: 'EUR', spain:'EUR', italy:'EUR', china:'人民币', america:'USD', canada:'CAD'}

  #   CSV.generate(options) do |csv|
  #     csv << xls_column_names
  #     all.un_shield.updated.each do |product|
  #       # Custome the xls values
  #       # csv << ['product.attributes.values_at(*column_names)', 'hello', 'world']
  #         # 父产品
  #       xls_column_values = []
  #       xls_column_values << product.sku[0..35].lstrip
  #       xls_column_values << ""
  #       if product.variables.count < 1
  #         xls_column_values << "UPC"
  #       else
  #         xls_column_values << ""
  #       end
  #       product_translation = Product.choose_language(language, product)
  #       xls_column_values << product_translation[:title]
  #       xls_column_values << ""
  #       xls_column_values << product.try(:price).try(:to_f) / cash_rate
  #       xls_column_values << country_currency[language.to_sym]
  #       xls_column_values << '' #stock
  #       xls_column_values << product.heel_height
  #       xls_column_values << product.seasons
  #       # if product.image_url
  #       images_url = [product.images1, product.images2, product.images3, product.images4, product.images5, product.images6,
  #                    product.images7, product.images8, product.images9, product.images10]
  #       images_url.each_with_index do |url,index|
  #         i_index = 0
  #         until images_url[i_index].blank?
  #           i_index = i_index + 1
  #         end
  #         if i_index < index
  #           images_url[i_index] = images_url[index]
  #           images_url[index] = ''
  #         end
  #       end
  #       xls_column_values << images_url[0]
  #       # else
  #         # xls_column_values << ""
  #       # end
  #       xls_column_values << ""
  #       xls_column_values << images_url[1]
  #       xls_column_values << images_url[2]
  #       xls_column_values << images_url[3]
  #       xls_column_values << images_url[4]
  #       xls_column_values << images_url[5]
  #       xls_column_values << images_url[6]
  #       xls_column_values << images_url[7]
  #       xls_column_values << images_url[8]
  #       if product.variables.count < 1
  #         xls_column_values << ""
  #       else
  #         xls_column_values << "parent"
  #       end
  #       xls_column_values << ""
  #       xls_column_values << ""
  #       variation_theme = ""
  #       unless product.try(:variables).try(:first).try(:color).blank?
  #         variation_theme << 'Color'
  #       end
  #       unless product.try(:variables).try(:first).try(:size).blank?
  #         variation_theme << 'Size'
  #       end      
  #       xls_column_values << variation_theme #variation theme
  #       xls_column_values << "" # color
  #       xls_column_values << "" # color
  #       xls_column_values << "" # size
  #       xls_column_values << "" # size
  #       xls_column_values << product.read_attribute("#{language}_detail")
  #       xls_column_values << product.read_attribute("outer_material_type_#{language}")
  #       # xls_column_values << product.read_attribute("inner_material_type_#{language}")
  #       xls_column_values << product.read_attribute("sole_material_#{language}")
  #       xls_column_values << product.read_attribute("heel_type_#{language}")
  #       xls_column_values << product.read_attribute("closure_type_#{language}")
  #       xls_column_values << ShoesAttributesValue.find(product.department_name).read_attribute("#{language}")
  #       xls_column_values << ShoesAttributesValue.find(product.style_name).read_attribute("#{language}")
  #       xls_column_values << ShoesAttributesValue.find(product.leather_type).read_attribute("#{language}")
  #       xls_column_values << ShoesAttributesValue.find(product.shaft_height).read_attribute("#{language}")
  #       xls_column_values << ShoesAttributesValue.find(product.shaft_diameter).read_attribute("#{language}")
  #       xls_column_values << ShoesAttributesValue.find(product.platform_height).read_attribute("#{language}")
  #       xls_column_values << ShoesAttributesValue.find(product.shoe_width).read_attribute("#{language}")
  #       xls_column_values << ShoesAttributesValue.find(product.lining_description).read_attribute("#{language}")
  #       xls_column_values << ShoesAttributesValue.find(product.strap_type).read_attribute("#{language}")
        
  #       csv << xls_column_values
  #       # 子产品
  #       product.variables.each do |v|
  #         xls_column_values = []
  #         v_color = ''
  #         v_size = ''
  #         v_variable_info_translation = v.variable_translate_history
  #         if v.color && v.size
  #           xls_column_values << "#{product.sku}-#{v_variable_info_translation.england_color}#{v_variable_info_translation.england_size}"[0..35].lstrip
  #           v_color = v_variable_info_translation.england_color
  #           v_size = v_variable_info_translation.england_size
  #         elsif v.color
  #           if v_variable_info_translation
  #             v_color = v_variable_info_translation.england_color
  #             v_size = ""
  #             xls_column_values << "#{product.sku}-#{v_color}"[0..35].lstrip
  #           else
  #             xls_column_values << "这个变体没有翻译，请重新翻译"  
  #           end
  #         elsif v.size
  #           if v_variable_info_translation
  #             v_size = v_variable_info_translation.england_size
  #             xls_column_values << "#{product.sku}-#{v_size}"[0..35].lstrip
  #           else
  #             xls_column_values << "这个变体没有翻译，请重新翻译"  
  #           end
  #         end
  #         xls_column_values << ""
  #         xls_column_values << "UPC"
  #         if v.color && v.size
  #           xls_column_values << "#{product_translation[:title]}-#{v_color} #{v_size}"
  #         elsif v.color
  #           xls_column_values << "#{product_translation[:title]}-#{v_color}"
  #         elsif v.size
  #           xls_column_values << "#{product_translation[:title]}-#{v_size}"
  #         end
  #         xls_column_values << ""
  #         xls_column_values << v.price.to_f / cash_rate
  #         xls_column_values << country_currency[language.to_sym]
  #         xls_column_values << v.stock
  #         xls_column_values << product.heel_height
  #         xls_column_values << product.seasons
  #         v_images_url = [v.image_url1,  v.image_url2,  v.image_url3,  v.image_url4,  v.image_url5,  v.image_url6,  v.image_url7,  v.image_url8,  v.image_url9,  v.image_url10,
  #                         v.image_url11, v.image_url12, v.image_url13, v.image_url14, v.image_url15, v.image_url16, v.image_url17, v.image_url18, v.image_url19, v.image_url20,
  #                         v.image_url21, v.image_url22, v.image_url23, v.image_url24, v.image_url25, v.image_url26, v.image_url27, v.image_url28, v.image_url29, v.image_url30]
  #         v_images_url.each_with_index do |url,index|
  #           i_index = 0
  #           until v_images_url[i_index].blank?
  #             i_index = i_index + 1
  #           end
  #           if i_index < index
  #             v_images_url[i_index] = v_images_url[index]
  #             v_images_url[index] = ''
  #           end
  #         end
  #         xls_column_values << v_images_url[0]
  #         xls_column_values << ""  # line 17
  #         xls_column_values << v_images_url[1]
  #         xls_column_values << v_images_url[2]
  #         xls_column_values << v_images_url[3]
  #         xls_column_values << v_images_url[4]
  #         xls_column_values << v_images_url[5]
  #         xls_column_values << v_images_url[6]
  #         xls_column_values << v_images_url[7]
  #         xls_column_values << v_images_url[8]
  #         xls_column_values << "child"
  #         xls_column_values << product.sku
  #         xls_column_values << "Variation"
  #         xls_column_values << variation_theme
  #         xls_column_values << "#{v_color}"
  #         xls_column_values << "#{v_color}"
  #         xls_column_values << "#{v_size}"
  #         xls_column_values << "#{v_size}"
  #         xls_column_values << product.read_attribute("#{language}_detail")
  #         xls_column_values << product.read_attribute("outer_material_type_#{language}")
  #         # xls_column_values << product.read_attribute("inner_material_type_#{language}")
  #         xls_column_values << product.read_attribute("sole_material_#{language}")
  #         xls_column_values << product.read_attribute("heel_type_#{language}")
  #         xls_column_values << product.read_attribute("closure_type_#{language}")
  #         xls_column_values << ShoesAttributesValue.find(product.department_name).read_attribute("#{language}")
  #         xls_column_values << ShoesAttributesValue.find(product.style_name).read_attribute("#{language}")
  #         xls_column_values << ShoesAttributesValue.find(product.leather_type).read_attribute("#{language}")
  #         xls_column_values << ShoesAttributesValue.find(product.shaft_height).read_attribute("#{language}")
  #         xls_column_values << ShoesAttributesValue.find(product.shaft_diameter).read_attribute("#{language}")
  #         xls_column_values << ShoesAttributesValue.find(product.platform_height).read_attribute("#{language}")
  #         xls_column_values << ShoesAttributesValue.find(product.shoe_width).read_attribute("#{language}")
  #         xls_column_values << ShoesAttributesValue.find(product.lining_description).read_attribute("#{language}")
  #         xls_column_values << ShoesAttributesValue.find(product.strap_type).read_attribute("#{language}")

  #         csv << xls_column_values
  #       end
  #     end
  #   end
  # end

  def save_attributes
    self.strap_type = ShoesAttributesValue.where(name:self.strap_type).first.try(:id)
    self.lining_description = ShoesAttributesValue.where(name:self.lining_description).first.try(:id)
    self.shoe_width = ShoesAttributesValue.where(name:self.shoe_width).first.try(:id)
    self.platform_height = ShoesAttributesValue.where(name:self.platform_height).first.try(:id)
    self.shaft_diameter = ShoesAttributesValue.where(name:self.shaft_diameter).first.try(:id)
    self.shaft_height = ShoesAttributesValue.where(name:self.shaft_height).first.try(:id)
    self.leather_type = ShoesAttributesValue.where(name:self.leather_type).first.try(:id)
    self.style_name = ShoesAttributesValue.where(name:self.style_name).first.try(:id)
    self.department_name = ShoesAttributesValue.where(name:self.department_name).first.try(:id)
    save
  end

  private

  def save_sku
    # get the last product's sku then add one on it
    if Product.all.count == 0
      base_number = 0
    else
      base_number = Product.last.sku_number.to_i
    end
    self.sku_number = base_number + 1

    self.sku = self.sku_number.to_s.prepend(("T" + "0" * (7- self.sku_number.to_s.length)) )
  end

end
