class VariablesController < ApplicationController
  before_action :set_variable, only: [:show, :edit, :update, :destroy]

  def remove_variable
    Variable.delete(params[:variable_id])
    render json:true
  end

  def variable_search
    @search_result = VariableTranslateHistory.where(word: params[:variable_name])
  end

  def variable_translate_list
    @variables = VariableTranslateHistory.color_variable.order('updated_at desc')
    @colors = VariableTranslateHistory.size_variable.order('updated_at desc')
  end

  def remove_translate_variable
    delete_flag = true
    variable_name = params[:variableName]
    variable_from = params[:variableType]
    if variable_from == 'size'
      using_variable = Variable.where(size: variable_name).first
    elsif variable_from == 'color'
      using_variable = Variable.where(color: variable_name).first
    end

    delete_flag = false if using_variable.present?

    if delete_flag
      variable_history = VariableTranslateHistory.where(word: variable_name, variable_from: variable_from).first
      if variable_history.present?
        variable_history.destroy
      else
      end
      @variables = Variable.select(:color).uniq
    else
      render json:1
    end
  end

  def update_translate_variable
    variable_translation_value_array = params[:variableTranslationValue].split(',')
    variable_name = params[:variableName]
    variable_from = params[:variableType]
    variable_history = VariableTranslateHistory.where(word: variable_name, variable_from: variable_from).first
    if variable_history.present?
      variable_history.update_attributes(en: variable_translation_value_array[0], de: variable_translation_value_array[3], fr: variable_translation_value_array[4], es: variable_translation_value_array[5], it: variable_translation_value_array[6])
    else
      VariableTranslateHistory.create(variable_from: variable_from, word: variable_name, en: variable_translation_value_array[0], de: variable_translation_value_array[3], fr: variable_translation_value_array[4], es: variable_translation_value_array[5], it: variable_translation_value_array[6])
    end

    unless params[:oldVariableName] == variable_name
      Variable.where(color: params[:oldVariableName]).update_all(color: variable_name, translate_status: true)
    end
    @variables = Variable.select(:color).uniq
  end

  def save_translate_variable
    variable_translation_value_array = params[:variableTranslationValue].split(',')
    variable_name = params[:variableName]
    VariableTranslateHistory.create(word: variable_name, en: variable_translation_value_array[0], de: variable_translation_value_array[3], fr: variable_translation_value_array[4], es: variable_translation_value_array[5], it: variable_translation_value_array[6])
    
    unless params[:oldVariableName] == variable_name
      Variable.where(color: params[:oldVariableName]).update_all(color: variable_name, translate_status: true)
    end
    @variables = Variable.untranslated.select(:color).uniq
  end

  def translate_variables
    @variables = Variable.untranslated.select(:color).uniq
  end

  def index
    @variables = Variable.all
  end

  def show
  end

  def new
    @variable = Variable.new
  end

  def edit
  end

  def create
    @variable = Variable.new(variable_params)

    respond_to do |format|
      if @variable.save
        variable_size = variable_params[:size]
        variable_color = variable_params[:color]

        if VariableTranslateHistory.where(word: variable_size, variable_from: 'size').count < 1
          VariableTranslateHistory.create(word: variable_size, variable_from: 'size', user: @variable.product.user)
        end

        if VariableTranslateHistory.where(word: variable_color, variable_from: 'color').count < 1
          VariableTranslateHistory.create(word: variable_color, variable_from: 'color', user: @variable.product.user)
        end

        format.html { redirect_to @variable, notice: 'Variable was successfully created.' }
        format.json { render :show, status: :created, location: @variable }
      else
        format.html { render :new }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variables/1
  # PATCH/PUT /variables/1.json
  def update
    respond_to do |format|
      if @variable.update(variable_params)
        format.html { redirect_to @variable, notice: 'Variable was successfully updated.' }
        format.json { render :show, status: :ok, location: @variable }
      else
        format.html { render :edit }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @variable.destroy
    respond_to do |format|
      format.html { redirect_to variables_url, notice: 'Variable was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_variable
      @variable = Variable.find(params[:id])
    end

    def variable_params
      params.require(:variable).permit(:color, :size, :price, :product_id, :deleted_at, :stock, :update_status, :translate_status,
                                       :image_url1, :image_url2,:image_url3,:image_url4, :image_url5,:image_url6, :image_url7, :image_url8,:image_url9, :image_url10,
                                       :image_url11, :image_url12,:image_url13,:image_url14, :image_url15,:image_url16, :image_url17, :image_url18,:image_url19, :image_url20,
                                       :image_url21, :image_url22,:image_url23,:image_url24, :image_url25,:image_url26, :image_url27, :image_url28,:image_url29, :image_url30,
                                       :england_color, :england_size, :germany_color, :germany_size, :france_color, :france_size, :spain_color, :spain_size,
                                       :italy_color, :italy_size,
                                       )
    end
end
