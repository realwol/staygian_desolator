namespace :product_check do
	desc 'check pre sale product'
	task :pre_sale => :environment do
		Product.pre_saled.each do |product|
			if Time.now > product.presale_date
				product.shield_type = 0
				product.save
			end
		end
	end
end
