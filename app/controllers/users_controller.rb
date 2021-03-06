class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :change_user_password]
  before_action :authenticate_user!

  def user_statistic
    if current_user.is_dd?
      all_updated_products = Product.updated.onsale.un_shield.pluck(:id)
      current_updated_product = Product.updated.onsale.un_shield.where(product_check_flag: true).last.try(:id)
      @all_updated_products_count = all_updated_products.count
      if current_updated_product
        @current_updated_product_count = all_updated_products.index(current_updated_product) + 1
      else
        @current_updated_product_counts = 0
      end
      @product_updated_percentage = (@current_updated_product_count.to_f / @all_updated_products_count.to_f * 100).round(1)

      @all_merchants_count = Merchant.count
      @updated_merchants_count = Merchant.where(update_flag: true).count
      @merchant_updated_percentage = (@updated_merchants_count.to_f / @all_merchants_count.to_f * 100).round(1)
    end
  end

  def show_little_brothers
    @user = User.find(params[:id])
    @user = @user.role > current_user.role ? @user : current_user
    if @user
      @users = @user.little_brothers
    else
      @users = nil
    end
  end

  def change_user_password
    if params[:new_password] == params[:new_password_confirmation]
      @user.update_attributes(email: params[:new_user_name], password: params[:new_password])
      @flag = 1
    else
      @flag = 2
    end
  end

  def set_selected_user
    if params[:select_type] == '1'
      params[:selected_user_id] = '1' if params[:selected_user_id].blank?
    elsif params[:select_type] == '2'
      params[:selected_user_id] = params[:manager_id] if params[:selected_user_id].blank?
      params[:selected_user_id] = current_user.id if params[:selected_user_id].blank?
    end

    @selected_user = User.find(params[:selected_user_id])
    if @selected_user.present?
      session[:selected_user_id] = @selected_user.id
    end
  end

  def create_new_user
    User.create(email: params[:new_user_email], password: params[:new_user_password], manager: current_user.id, role: current_user.role + 1)
    @users = current_user.little_brothers
  end

  def index
      @users = current_user.little_brothers
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params[:user]
    end
end
