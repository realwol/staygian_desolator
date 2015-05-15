class ShopsController < ApplicationController
	before_action :set_shop, only: [:edit, :update, :destroy]

	def edit
	end

	def update
		@shop.update_attributes(name:params[:shop][:name])
		redirect_to get_tmall_links_products_url
	end

	def destroy
		@shop.destroy
		redirect_to get_tmall_links_products_url
	end

	private
	def set_shop
		@shop = Shop.find(params[:id])
	end
end