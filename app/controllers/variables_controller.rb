class VariablesController < ApplicationController
  before_action :set_variable, only: [:show, :edit, :update, :destroy]

  # GET /variables
  # GET /variables.json
  def index
    @variables = Variable.all
  end

  # GET /variables/1
  # GET /variables/1.json
  def show
  end

  # GET /variables/new
  def new
    @variable = Variable.new
  end

  # GET /variables/1/edit
  def edit
  end

  # POST /variables
  # POST /variables.json
  def create
    @variable = Variable.new(variable_params)

    respond_to do |format|
      if @variable.save
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

  # DELETE /variables/1
  # DELETE /variables/1.json
  def destroy
    @variable.destroy
    respond_to do |format|
      format.html { redirect_to variables_url, notice: 'Variable was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable
      @variable = Variable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
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
