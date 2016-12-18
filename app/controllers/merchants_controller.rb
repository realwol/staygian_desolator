class MerchantsController < ApplicationController
  before_action :set_merchant, only: [:edit, :update, :stop_merchant, :destroy, :add_merchant_product, :update_shipment_cost, :get_merchant_skus]

  def add_account_backup
    account = Account.find_by(id: params[:id])
    account.update_attributes(backup: params[:backup]) if account.present?
  end

  def clean_account
    account = Account.find(params[:id])
    account.merchants.update_all(is_removed: true)
    account.update_attributes(is_removed: true)

    account.merchants.each do |merchant|
      merchant.orders.order_in_forty_days.each do |order|
        puts "order id #{order.id}"
        refund_amount = order.amount + order.order_items.sum(:shipping_charge_amount).to_f
        RefundList.create(refund_date: Time.now, refund_type: 1, order_id: order.id, refund_amount: refund_amount, currency: order.currency, backup: params[:backup_info], buyer_memo: params[:buyer_memo], refund_reason: params[:refund_reason])
        order.update_attributes(order_ship_status: 'Refund')
        order.order_items.each do |item|
          item.update_attributes(commission_amount: 0, commission_rmb: 0, order_item_ship_status: 'Refund', refund_amount: (item.principal_amount + item.shipping_charge_amount), refund_currency: item.principal_currency, refund_rmb: (item.principal_rmb+item.shipping_charge_rmb))
        end
      end
    end
  end

  def clean_merchant
    merchant = Merchant.find(params[:id])
    merchant.update_attributes(is_removed: true)
    merchant.orders.order_in_forty_days.each do |order|
      refund_amount = order.amount + order.order_items.sum(:shipping_charge_amount).to_f
      RefundList.create(refund_date: Time.now, refund_type: 1, order_id: order.id, refund_amount: refund_amount, currency: order.currency, backup: params[:backup_info], buyer_memo: params[:buyer_memo], refund_reason: params[:refund_reason])
      order.update_attributes(order_ship_status: 'Refund')
      order.order_items.each do |item|
        item.update_attributes(commission_amount: 0, commission_rmb: 0, order_item_ship_status: 'Refund', refund_amount: (item.principal_amount + item.shipping_charge_amount), refund_currency: item.principal_currency, refund_rmb: (item.principal_rmb+item.shipping_charge_rmb))
      end
    end
  end

  def update_account_name
    new_name = params[:new_name]
    account_id = params[:account_id]
    if account_id.present?
      account = Account.find(account_id)
      account.update_attributes(name: new_name) if account.present?
    end
    render json:true
  end

  def account_list
    @accounts = current_user.valid_account.order('is_removed')
    @user_manage_auth = current_user.has_manage_auth?
    # @removed_accounts = current_user.removed_accounts
  end

  def create_account
    Account.create(name: params[:name], platform: params[:platform], user: current_user)
    @accounts = current_user.valid_account
  end

  def remove_account
    account = Account.find(params[:id])
    account.destroy
    @accounts = current_user.valid_account
  end

  def set_account_updated
    account = Account.find(params[:id])
    if account.present?
      account.merchants.each do |m|
        m.get_merchant_products.update_all(america_price_change: false, canada_price_change: false, british_price_change: false, germany_price_change: false, france_price_change: false, spain_price_change: false, italy_price_change: false)
      end
    end
    render json: true
  end

  def export_all_account
    aa = Time.now
    accounts = current_user.valid_account
    account_file_names, folder_array = [], []
    accounts.each do |account|
      puts "export account #{account.id}"
      folder = "public/export/#{account.name}#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}/"
      folder_array << folder
      # create files
      system("mkdir #{folder}")
      input_filenames = []
      account.merchants.not_removed.each do |m|
        puts "export merchant #{m.id}"
        file_name = "#{m.shop_name}.txt"
        input_filenames << file_name
        account_file_names << "#{folder}#{file_name}"
        file = File.open("#{folder}#{file_name}", 'a+')
        file.puts("sku\tprice\tminimum-seller-allowed-price\tmaximum-seller-allowed-price\tquantity\tleadtime-to-ship\t\n")
        country = m.merchant_country_name
        merchant_shipment_cost = m.shipment_cost.to_f
        symbol_count = 0
        old_sku_products, new_sku_products = m.get_merchant_products country
        old_sku_products.each do |p|
            # if p.inventory != 0
              if p.read_attribute("#{country}_price_change")
                if p.product_id.present?
                  product = Product.find(p.product_id)
                  p_sku = p.sku.strip
                  p_inventory = p.inventory > 100 ? 100 : p.inventory
                  if product.stock_should_zero?
                    if symbol_count
                      file.puts("\"#{p_sku}\"\t#{(p.read_attribute(country) - merchant_shipment_cost).to_i}\t\t\t0\t\n")
                      symbol_count = false
                    else
                      file.puts("#{p_sku}\t#{(p.read_attribute(country) - merchant_shipment_cost).to_i}\t\t\t0\t\n")
                    end
                  else
                    if symbol_count
                      file.puts("\"#{p_sku}\"\t#{(p.read_attribute(country) - merchant_shipment_cost).to_i}\t\t\t#{p_inventory}\t\n")
                      symbol_count = false
                    else
                      file.puts("#{p_sku}\t#{(p.read_attribute(country) - merchant_shipment_cost).to_i}\t\t\t#{p_inventory}\t\n")
                    end
                  end
                else
                  if symbol_count
                    file.puts("\"#{p_sku}\"\t#{(p.read_attribute(country) - merchant_shipment_cost).to_i}\t\t\t#{p_inventory}\t\n")
                    symbol_count = false
                  else
                    file.puts("#{p_sku}\t#{(p.read_attribute(country) - merchant_shipment_cost).to_i}\t\t\t#{p_inventory}\t\n")
                  end
                end
              end
            # end
        end
        new_sku_products.each do |p|
            # if p.inventory != 0
              if p.read_attribute("#{country}_price_change")
                if p.product_id.present?
                  product = Product.find(p.product_id)
                  p_sku = p.sku1.strip
                  if product.stock_should_zero?
                    if symbol_count
                      file.puts("\"#{p_sku}\"\t#{(p.read_attribute(country) - merchant_shipment_cost).to_i}\t\t\t0\t\n")
                      symbol_count = false
                    else
                      file.puts("#{p_sku}\t#{(p.read_attribute(country) - merchant_shipment_cost).to_i}\t\t\t0\t\n")
                    end
                  else
                    if symbol_count
                      file.puts("\"#{p_sku}\"\t#{(p.read_attribute(country) - merchant_shipment_cost).to_i}\t\t\t#{p_inventory}\t\n")
                      symbol_count = false
                    else
                      file.puts("#{p_sku}\t#{(p.read_attribute(country) - merchant_shipment_cost).to_i}\t\t\t#{p_inventory}\t\n")
                    end
                  end
                else
                  if symbol_count
                    file.puts("\"#{p_sku}\"\t#{(p.read_attribute(country) - merchant_shipment_cost).to_i}\t\t\t#{p_inventory}\t\n")
                    symbol_count = false
                  else
                    file.puts("#{p_sku}\t#{(p.read_attribute(country) - merchant_shipment_cost).to_i}\t\t\t#{p_inventory}\t\n")
                  end
                end
              end
            # end
        end
        symbol_count = true
        file.close
      end
    end

    puts 'done export update.'
    big_folder = "public/export"
    bigzipfile_name = "#{big_folder}/all_accounts-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.zip"
    Zip::File.open(bigzipfile_name, Zip::File::CREATE) do |zipfile|
      account_file_names.each do |filename|
        # Two arguments:
        # - The name of the file as it will appear in the archive
        # - The original file, including the path to find it
        zipfile.add(filename.gsub('public/export/',''), filename)
      end
    end
    
    send_file bigzipfile_name, :type=> 'application/text', :x_sendfile=>true
    folder_array.each do |filename|
      FileUtils.rm_rf filename
    end
  end

  def export_account
    start_time = Time.now
    account = Account.find(params[:id])
    account_name = account.name.gsub(' ', '')
    folder = "public/export/#{account_name}#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}/"

    # create files
    system("mkdir #{folder}")
    input_filenames = []
    account.merchants.not_removed.each do |m|
      file_name = "#{m.shop_name}.txt"
      input_filenames << file_name
      file = File.open("#{folder}/#{file_name}", 'a+')
      file.puts("sku\tprice\tminimum-seller-allowed-price\tmaximum-seller-allowed-price\tquantity\tleadtime-to-ship\t\n")
      country = m.merchant_country_name
      merchant_shipment_cost = m.shipment_cost.to_f
      symbol_count = 0
      old_sku_products, new_sku_products = m.get_merchant_products country
      # backup_products = Product.where(id: old_sku_products.pluck(:product_id).concat(new_sku_products.pluck(:product_id)))

      if old_sku_products.present?
        old_prev_product = nil
        old_sku_products.each do |p|
          # if p.inventory != 0
            if p.read_attribute("#{country}_price_change")
              if p.product_id.present?
                if p.product_id == old_prev_product.try(:id)
                  product = old_prev_product
                else
                  puts 1
                  product = Product.find(p.product_id)
                  old_prev_product = product
                end
                p_sku = p.sku.strip
                p_inventory = p.inventory > 100 ? 100 : p.inventory
                if symbol_count ==0
                  country_price = p.read_attribute(country).present? ? p.read_attribute(country) : 0
                  if product.present? && product.stock_should_zero?
                    file.puts("\"#{p_sku}\"\t#{(country_price - merchant_shipment_cost).to_i}\t\t\t0\t\n")
                  else
                    file.puts("\"#{p_sku}\"\t#{(country_price - merchant_shipment_cost).to_i}\t\t\t#{p_inventory}\t\n")
                  end
                  symbol_count = 1
                else
                  country_price = p.read_attribute(country).present? ? p.read_attribute(country) : 0
                  if product.present? && product.stock_should_zero?
                    file.puts("#{p_sku}\t#{(country_price - merchant_shipment_cost).to_i}\t\t\t0\t\n")
                  else
                    file.puts("#{p_sku}\t#{(country_price - merchant_shipment_cost).to_i}\t\t\t#{p_inventory}\t\n")
                  end
                end
              end
            end
          # end
        end
      end

      if new_sku_products.present?
        new_sku_products.each do |p|
          # if p.inventory != 0
          new_prev_product = nil
            if p.read_attribute("#{country}_price_change")
              if p.product_id.present?
                if new_prev_product.try(:id) == p.product_id
                  product = new_prev_product
                else
                  puts 2
                  product = Product.find(p.product_id)
                  new_prev_product = product
                end
              end
              p_sku = p.sku1.strip
              p_inventory = p.inventory > 100 ? 100 : p.inventory
              if symbol_count ==0
                country_price = p.read_attribute(country).present? ? p.read_attribute(country) : 0
                if product.present? && product.stock_should_zero?
                  file.puts("\"#{p_sku}\"\t#{(country_price - merchant_shipment_cost).to_i}\t\t\t0\t\n")
                else
                  file.puts("\"#{p_sku}\"\t#{(country_price - merchant_shipment_cost).to_i}\t\t\t#{p_inventory}\t\n")
                end
                symbol_count = 1
              else
                country_price = p.read_attribute(country).present? ? p.read_attribute(country) : 0
                if product.present? && product.stock_should_zero?
                  file.puts("#{p_sku}\t#{(country_price - merchant_shipment_cost).to_i}\t\t\t0\t\n")
                else
                  file.puts("#{p_sku}\t#{(country_price - merchant_shipment_cost).to_i}\t\t\t#{p_inventory}\t\n")
                end
              end
            end
        end
      end
      symbol_count = 0
      file.close
    end

    zipfile_name = "#{folder}#{account_name}-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.zip"
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        # Two arguments:
        # - The name of the file as it will appear in the archive
        # - The original file, including the path to find it
        zipfile.add(filename, folder + '/' + filename)
      end
      # zipfile.get_output_stream("myFile") { |os| os.write "myFile contains just this" }
    end
    puts '======================================', Time.now - start_time
    send_file zipfile_name, :type=> 'application/text', :x_sendfile=>true
  end

  def remove_merchant_binding_sku
    merchant = Merchant.find(params[:id])
    merchant.merchant_sku_relations.delete_all
    render json: true
  end

  def get_merchant_skus
    sku_array = @merchant.merchant_sku_relations.pluck(:sku)
    # sku_array = MerchantSkuRelation.where('merchant_id = ?', @merchant.id).select(:sku)
    if sku_array.present?
      skus = sku_array
    end
    render json: skus
  end

  def update_shipment_cost
    unless @merchant.shipment_cost == params[:shipment_cost]
      @merchant.update_attributes(shipment_cost: params[:shipment_cost])
      @merchant.reset_all_sku_price
    end
    render json:true
  end

  def index
    if current_user.is_dd?
      @merchants = Merchant.all
    else
      @merchants = current_user.valid_merchants
    end
    @account = Account.find(params[:account_id])
    @merchants = @account.merchants
  end

  def create
    mws_points = {america: 'https://mws.amazonservices.com', canada: 'https://mws.amazonservices.ca', british: 'https://mws-eu.amazonservices.com', germany: 'https://mws-eu.amazonservices.com', spain: 'https://mws-eu.amazonservices.com', italy: 'https://mws-eu.amazonservices.com', france: 'https://mws-eu.amazonservices.com' }
    mws_marketplace_id = {america: 'ATVPDKIKX0DER', canada: 'A2EUQ1WTGCTBG2', british: 'A1F83G8C2ARO7P', germany: 'A1PA6795UKMFR9', spain: 'A1RKKUPIHCS9HS', italy: 'APJ6JRA9NG5V4', france: 'A13V1IB3VIYZZH' }
    params[:merchant_api_address] = mws_points["#{merchant_params[:merchant_country_name]}".to_sym]
    params[:merchant_marketplace_id] = mws_marketplace_id["#{merchant_params[:merchant_country_name]}".to_sym]
    current_user.merchants.create(merchant_params)
    @account = Account.find(merchant_params[:account_id])
    @merchants = @account.merchants
  end

  def edit
  end

  def update
    @merchant.update_attributes(merchant_params)
    redirect_to action: :index
  end

  def stop_merchant
    @merchant.update_attributes(status: false)
    render json:true
  end

  def add_merchant_product
    product_sku = params[:product_sku]
    merchant_sku_relation_array = []
    merchant_sku_relation_test_array = []
    a = Time.now
    pre_product = ''
    pre_sku = 'FLAGNIL'
    product_sku_array = product_sku.split("\n")
    product_sku_array.each do |sku|
      index = sku.index('-')
      if index.present?
        sku_part = sku[0..index-1]
      else
        sku_part = sku
      end
      if pre_product != 'FLAGNIL' && pre_sku == sku_part
        product = pre_product
      else
        product = Product.find_by(sku: sku_part)
        product = Product.where(sku1: sku_part).first unless product.present?
        pre_product = product
        pre_sku = sku_part
      end
      # if sku.present?
      #   # unless MerchantSkuRelation.find_by(sku: sku, merchant_id: @merchant.id)
      #     merchant_sku_hash = {}
      #     merchant_sku_hash[:merchant_id] = @merchant.id
      #     merchant_sku_hash[:sku] = sku
      #     merchant_sku_hash[:product_id] = product.try(:id)
      #     merchant_sku_relation_array << merchant_sku_hash
      #   # end
      # end
      create_time = Time.now.strftime("%Y-%m-%d")
      if product.present?
        merchant_sku_relation_test_array << "('#{@merchant.id}', '#{product.try(:id)}', '#{sku}', '#{create_time}', '#{create_time}')"
      else
        merchant_sku_relation_test_array << "('#{@merchant.id}', NULL, '#{sku}', '#{create_time}', '#{create_time}')"
      end
    end
    # MerchantSkuRelation.create(merchant_sku_relation_array)
    abc = merchant_sku_relation_test_array.split(',').flatten
    aaa = "insert into merchant_sku_relations (merchant_id, product_id, sku, created_at, updated_at) values"
    aaab = ''
    abc.each do |bc|
      aaab << bc +','
    end
    aaa = aaa + aaab[0..-2] + ';'
    count = merchant_sku_relation_test_array.count + 1
    connection = ActiveRecord::Base.connection
    connection.execute(aaa)
    puts Time.now - a
    puts count
    render json:true
  end

  def destroy
    if @merchant.present?
      @merchant.destroy
    end
    render json:true
  end

  private
  def merchant_params
    params.permit(:shop_name, :merchant_plantform_name, :merchant_account, :merchant_country_name, :merchant_type, :merchant_aws_access_key_id, :merchant_secret_key, :merchant_seller_id, :merchant_marketplace_id, :merchant_api_address, :account_id)
  end

  def set_merchant
    @merchant = Merchant.find(params[:id])
  end
end
