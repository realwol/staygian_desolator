class Variable < ActiveRecord::Base
	acts_as_paranoid
  belongs_to :product
  belongs_to :variable_translate_history

  scope :untranslated, ->{unscope(where: :update_status).where(translate_status: false)}

  before_save :save_dup

  def valid_images
  	image_names = []
  	1.upto(30) do |t|
  		image_names << "image_url#{t}"
  	end

  	@valid_images = []
  	image_names.each do |attr|
  		@valid_images << self.read_attribute("#{attr}") unless self.read_attribute("#{attr}").blank?
  	end

  	@valid_images
  end

  def self.update_product_variable(options, product)
    return if options.blank?
    variables = product.variables
    variable =''
    options.each do |option|
        variables.each do |v|
          if v.id == option["index"].to_i
            variable = v
            break
          end
        end
      option.delete("index")

      if option.blank?
        variable.update_attributes(update_status:true)
      else
        image_urls = []
        1.upto(30) do |n|
          image_urls << "image_url#{n}".to_sym
        end
        urls = []
        image_urls.each do |i|
          unless option[i].blank?
            urls << option[i]
            option[i] = ''
          end
        end
        urls.each_with_index do |url,index|
          option[image_urls[index]] = url
        end

        option["update_status"] = false

        variable.update_attributes(variable_params(option))
      end
    end
  end

  def choose_variable_translation(language, type)
    self.public_send("#{language}_#{type}")
  end

  private
    def self.variable_params option
      option.permit(:color, :size, :price, :product_id, :deleted_at, :stock, :update_status, :translate_status,
                                       :image_url1, :image_url2,:image_url3,:image_url4, :image_url5,:image_url6, :image_url7, :image_url8,:image_url9, :image_url10,
                                       :image_url11, :image_url12,:image_url13,:image_url14, :image_url15,:image_url16, :image_url17, :image_url18,:image_url19, :image_url20,
                                       :image_url21, :image_url22,:image_url23,:image_url24, :image_url25,:image_url26, :image_url27, :image_url28,:image_url29, :image_url30,
                                       :england_color, :england_size, :germany_color, :germany_size, :france_color, :france_size, :spain_color, :spain_size,
                                       :italy_color, :italy_size, :color_dup, :size_dup)
    end

    def save_dup
      color_dup = color
      size_dup = size
    end
end
