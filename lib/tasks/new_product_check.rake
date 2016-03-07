namespace :new_product_check do
  desc 'get new product'
  task :check => :environment do
    shop_link = get_shop_link
    
  end
end

def get_shop_link
  # check shop link one by one, if one link is done checking, no need to check the rest links in the same shop
  TmallLink.first
end
