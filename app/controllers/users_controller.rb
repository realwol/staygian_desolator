class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :change_user_password, :user_setting, :reset_user_pwd, :admin_reset_user_pwd]
  before_action :authenticate_user!

  def update_responser
    account = Account.find(params[:account_id])
    account.update_attributes(user_id: params[:user_id]) if account.present?
    render json:true
  end

  def user_setting
    
  end

  def create_user_from_depart
    create_user_from_department_param[:manager] = current_user.id
    if params[:update_user_id].present?
      User.find(params[:update_user_id]).update_attributes(create_user_from_department_param)
    else
      User.create(create_user_from_department_param)
    end

    @department = Department.find(params[:department_id])
    @department_users = @department.users
  end

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

  def reset_user_pwd
    if @user.valid_password?(params[:old_pwd])
      @user.update_attributes(password: params[:new_pwd])      
      render json: 1
    else
      render json: 0
    end
  end

  def admin_reset_user_pwd
    if params[:new_password].present?
      @user.update_attributes(password: params[:new_password])
      render json: 1
    else
      render json: 0
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
      params[:selected_user_id] = nil if params[:selected_user_id].blank?
    elsif params[:select_type] == '2'
      params[:selected_user_id] = params[:manager_id] if params[:selected_user_id].blank?
      params[:selected_user_id] = current_user.id if params[:selected_user_id].blank?
    end

    if params[:selected_user_id].present?
      @selected_user = User.find(params[:selected_user_id])
      if @selected_user.present?
        session[:selected_user_id] = @selected_user.id
      end
    else
      session[:selected_user_id] = nil
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

    def create_user_from_department_param
      params.permit( :order_role, :email, :username, :password, :leader_id, :user_role_id, :manager, :department_id, :user_product_version)
    end
end
