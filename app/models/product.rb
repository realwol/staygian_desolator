class Product < ActiveRecord::Base
	acts_as_paranoid
  belongs_to :product_type
  belongs_to :user
  belongs_to :shop

  has_many :variables
  accepts_nested_attributes_for :variables

  has_one :product_info_translation

  scope :un_updated, -> {where(update_status:false)}
  scope :updated, -> {where(update_status:true)}
  scope :un_shield, -> {where(shield_type: 0)}
  scope :shield, -> {where(shield_type: 1)}
  scope :edited, -> {where(shield_type: 4)}
  scope :onsale, -> {where(on_sale: true)}
  scope :offsale, -> {where(on_sale: false).un_shield}
  scope :temp_offsale, -> {where(shield_type: 3).where(on_sale:false)}
  scope :pre_saled, -> {where.not(presale_date: nil).where(shield_type:2).where(on_sale:false)}

  before_create :save_sku

  mount_uploader :avatar, AvatarUploader
  mount_uploader :avatar1, AvatarUploader
  mount_uploader :avatar2, AvatarUploader

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

  def self.choose_language(language, product)
    local_infos = {}
    product_translation = product.product_info_translation
    case language
    when 'england'
      local_infos[:title] = product_translation.try(:e_t)
      local_infos[:des1] = product_translation.try(:e_des1)
      local_infos[:des2] = product_translation.try(:e_des2)
      local_infos[:des3] = product_translation.try(:e_des3)
    when 'germany'
      local_infos[:title] = product_translation.try(:g_t)
      local_infos[:des1] = product_translation.try(:g_des1)
      local_infos[:des2] = product_translation.try(:g_des2)
      local_infos[:des3] = product_translation.try(:g_des3)
    when 'france'
      local_infos[:title] = product_translation.try(:f_t)
      local_infos[:des1] = product_translation.try(:f_des1)
      local_infos[:des2] = product_translation.try(:f_des2)
      local_infos[:des3] = product_translation.try(:f_des3)
    when 'spain'
      local_infos[:title] = product_translation.try(:s_t)
      local_infos[:des1] = product_translation.try(:s_des1)
      local_infos[:des2] = product_translation.try(:s_des2)
      local_infos[:des3] = product_translation.try(:s_des3)
    when 'italy'
      local_infos[:title] = product_translation.try(:i_t)
      local_infos[:des1] = product_translation.try(:i_des1)
      local_infos[:des2] = product_translation.try(:i_des2)
      local_infos[:des3] = product_translation.try(:i_des3)
    when 'america'
      local_infos[:title] = product_translation.try(:e_t)
      local_infos[:des1] = product_translation.try(:e_des1)
      local_infos[:des2] = product_translation.try(:e_des2)
      local_infos[:des3] = product_translation.try(:e_des3)
    when 'canada'
      local_infos[:title] = product_translation.try(:e_t)
      local_infos[:des1] = product_translation.try(:e_des1)
      local_infos[:des2] = product_translation.try(:e_des2)
      local_infos[:des3] = product_translation.try(:e_des3)
    else
      local_infos[:title] = product.title
      local_infos[:des1] = product.product_intro_1
      local_infos[:des2] = product.product_intro_2
      local_infos[:des3] = product.product_intro_3
    end
    local_infos
  end


  def self.to_csv(language, options={})
    cash_rate = CashRate.last.try(language.to_sym).to_f
    # Custome the xls columns and languages
    xls_column_names = ["item_sku","external_product_id", "external_product_type","item_name", "brand_name",
                        "standard_price", "Currency", "Stock", "Heel_height", "Seasons",
                        "main_image_url", "switch_image_url", "other_image_url1", "other_image_url2",
                        "other_image_url3", "other_image_url4","other_image_url5", "other_image_url6",
                        "other_image_url7", "other_image_url8", "parent_child", "parent_sku", "relationship_type",
                        "variation_theme", "color_name", "color_map", "size_name", "size_map", "Details",
                        "Outer_material_type", "Inner_material_type", "Sole_material", "Closure_type", "Heel_type"]

    country_currency = {england:'GBP', germany:'EUR', france: 'EUR', spain:'EUR', italy:'EUR', china:'人民币', america:'USD', canada:'CAD'}

    CSV.generate(options) do |csv|
      csv << xls_column_names
      all.un_shield.updated.each do |product|
        # Custome the xls values
        # csv << ['product.attributes.values_at(*column_names)', 'hello', 'world']
          # 父产品
        xls_column_values = []
        xls_column_values << product.sku[0..35].lstrip
        xls_column_values << ""
        if product.variables.count < 1
          xls_column_values << "UPC"
        else
          xls_column_values << ""
        end
        product_translation = Product.choose_language(language, product)
        xls_column_values << product_translation[:title]
        xls_column_values << ""
        xls_column_values << product.try(:price).try(:to_f) / cash_rate
        xls_column_values << country_currency[language.to_sym]
        xls_column_values << '' #stock
        xls_column_values << product.heel_height
        xls_column_values << product.seasons
        # if product.image_url
        images_url = [product.images1, product.images2, product.images3, product.images4, product.images5, product.images6,
                     product.images7, product.images8, product.images9, product.images10]
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
        xls_column_values << ""
        xls_column_values << images_url[1]
        xls_column_values << images_url[2]
        xls_column_values << images_url[3]
        xls_column_values << images_url[4]
        xls_column_values << images_url[5]
        xls_column_values << images_url[6]
        xls_column_values << images_url[7]
        xls_column_values << images_url[8]
        if product.variables.count < 1
          xls_column_values << ""
        else
          xls_column_values << "parent"
        end
        xls_column_values << ""
        xls_column_values << ""
        variation_theme = ""
        unless product.try(:variables).try(:first).try(:color).blank?
          variation_theme << 'Color'
        end
        unless product.try(:variables).try(:first).try(:size).blank?
          variation_theme << 'Size'
        end      
        xls_column_values << variation_theme #variation theme
        xls_column_values << "" # color
        xls_column_values << "" # color
        xls_column_values << "" # size
        xls_column_values << "" # size
        xls_column_values << product.read_attribute("#{language}_detail")
        xls_column_values << product.read_attribute("outer_material_type_#{language}")
        # xls_column_values << product.read_attribute("inner_material_type_#{language}")
        xls_column_values << product.read_attribute("sole_material_#{language}")
        xls_column_values << product.read_attribute("heel_type_#{language}")
        xls_column_values << product.read_attribute("closure_type_#{language}")
        xls_column_values << ShoesAttributesValue.find(product.department_name).read_attribute("#{language}")
        xls_column_values << ShoesAttributesValue.find(product.style_name).read_attribute("#{language}")
        xls_column_values << ShoesAttributesValue.find(product.leather_type).read_attribute("#{language}")
        xls_column_values << ShoesAttributesValue.find(product.shaft_height).read_attribute("#{language}")
        xls_column_values << ShoesAttributesValue.find(product.shaft_diameter).read_attribute("#{language}")
        xls_column_values << ShoesAttributesValue.find(product.platform_height).read_attribute("#{language}")
        xls_column_values << ShoesAttributesValue.find(product.shoe_width).read_attribute("#{language}")
        xls_column_values << ShoesAttributesValue.find(product.lining_description).read_attribute("#{language}")
        xls_column_values << ShoesAttributesValue.find(product.strap_type).read_attribute("#{language}")
        
        csv << xls_column_values
        # 子产品
        product.variables.each do |v|
          xls_column_values = []
          v_color = ''
          v_size = ''
          v_variable_info_translation = v
          if v.color && v.size
            xls_column_values << "#{product.sku}-#{v_variable_info_translation.england_color}#{v_variable_info_translation.england_size}"[0..35].lstrip
            v_color = v_variable_info_translation.england_color
            v_size = v_variable_info_translation.england_size
          elsif v.color
            if v_variable_info_translation
              v_color = v_variable_info_translation.england_color
              v_size = ""
              xls_column_values << "#{product.sku}-#{v_color}"[0..35].lstrip
            else
              xls_column_values << "这个变体没有翻译，请重新翻译"  
            end
          elsif v.size
            if v_variable_info_translation
              v_size = v_variable_info_translation.england_size
              xls_column_values << "#{product.sku}-#{v_size}"[0..35].lstrip
            else
              xls_column_values << "这个变体没有翻译，请重新翻译"  
            end
          end
          xls_column_values << ""
          xls_column_values << "UPC"
          if v.color && v.size
            xls_column_values << "#{product_translation[:title]}-#{v_color} #{v_size}"
          elsif v.color
            xls_column_values << "#{product_translation[:title]}-#{v_color}"
          elsif v.size
            xls_column_values << "#{product_translation[:title]}-#{v_size}"
          end
          xls_column_values << ""
          xls_column_values << v.price.to_f / cash_rate
          xls_column_values << country_currency[language.to_sym]
          xls_column_values << v.stock
          xls_column_values << product.heel_height
          xls_column_values << product.seasons
          v_images_url = [v.image_url1,  v.image_url2,  v.image_url3,  v.image_url4,  v.image_url5,  v.image_url6,  v.image_url7,  v.image_url8,  v.image_url9,  v.image_url10,
                          v.image_url11, v.image_url12, v.image_url13, v.image_url14, v.image_url15, v.image_url16, v.image_url17, v.image_url18, v.image_url19, v.image_url20,
                          v.image_url21, v.image_url22, v.image_url23, v.image_url24, v.image_url25, v.image_url26, v.image_url27, v.image_url28, v.image_url29, v.image_url30]
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
          xls_column_values << ""  # line 17
          xls_column_values << v_images_url[1]
          xls_column_values << v_images_url[2]
          xls_column_values << v_images_url[3]
          xls_column_values << v_images_url[4]
          xls_column_values << v_images_url[5]
          xls_column_values << v_images_url[6]
          xls_column_values << v_images_url[7]
          xls_column_values << v_images_url[8]
          xls_column_values << "child"
          xls_column_values << product.sku
          xls_column_values << "Variation"
          xls_column_values << variation_theme
          xls_column_values << "#{v_color}"
          xls_column_values << "#{v_color}"
          xls_column_values << "#{v_size}"
          xls_column_values << "#{v_size}"
          xls_column_values << product.read_attribute("#{language}_detail")
          xls_column_values << product.read_attribute("outer_material_type_#{language}")
          # xls_column_values << product.read_attribute("inner_material_type_#{language}")
          xls_column_values << product.read_attribute("sole_material_#{language}")
          xls_column_values << product.read_attribute("heel_type_#{language}")
          xls_column_values << product.read_attribute("closure_type_#{language}")
          xls_column_values << ShoesAttributesValue.find(product.department_name).read_attribute("#{language}")
          xls_column_values << ShoesAttributesValue.find(product.style_name).read_attribute("#{language}")
          xls_column_values << ShoesAttributesValue.find(product.leather_type).read_attribute("#{language}")
          xls_column_values << ShoesAttributesValue.find(product.shaft_height).read_attribute("#{language}")
          xls_column_values << ShoesAttributesValue.find(product.shaft_diameter).read_attribute("#{language}")
          xls_column_values << ShoesAttributesValue.find(product.platform_height).read_attribute("#{language}")
          xls_column_values << ShoesAttributesValue.find(product.shoe_width).read_attribute("#{language}")
          xls_column_values << ShoesAttributesValue.find(product.lining_description).read_attribute("#{language}")
          xls_column_values << ShoesAttributesValue.find(product.strap_type).read_attribute("#{language}")

          csv << xls_column_values
        end
      end
    end
  end

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
    if Product.with_deleted.count == 0
      base_number = 0
    else
      base_number = Product.unscope(:where).with_deleted.last.sku_number.to_i
    end
    self.sku_number = base_number + 1

    self.sku = self.sku_number.to_s.prepend(("T" + "0" * (7- self.sku_number.to_s.length)) )
  end

end
