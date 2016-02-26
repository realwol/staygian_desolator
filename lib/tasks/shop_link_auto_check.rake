
def get_first_shop_link
  link = ShopLink.un_grasp.from_search.first
  if link.present?
    link
  else
    ShopLink.need_retry.from_search.first
  end
end

def filter_product product_html, shop_id
  if shop_id.present? && product_html.present?
    shop = Shop.find(shop_id)
    product_html.at('a.productShop-name').attributes['href'].value.index(shop.shop_id).nil?
  else
    false
  end
end

def grasp_shop link
  # OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  # I_KNOW_THAT_OPENSSL_VERIFY_PEER_EQUALS_VERIFY_NONE_IS_WRONG = nil
  agent = UserAgents.rand()
  # agent = Mechanize.new
  page = Nokogiri::HTML(open(link.link, 'User-Agent' => agent, :allow_redirections => :all ))

  if page.title == '上天猫，就够了'
    puts '***********************'
    puts '*                     *'
    puts '* behind the wall now *'
    puts '*                     *'
    puts '***********************'
    return
  else

    a = page.at('#J_ItemList')
    if a.nil?
      # next uri
      if (page.at('.ui-page-next') && page.at('.ui-page-next').attributes["href"])
        next_uri = page.at('.ui-page-next').attributes["href"].value
      else
        next_uri = ''
      end

      uri = link.link
      unless next_uri.blank?
        unless next_uri == ''
          new_url = 'https://list.tmall.com/search_product.htm' + next_uri
          puts new_url
          if ShopLink.where(link: new_url).count > 0
            puts 'old next url'
          else
            ShopLink.create(shop_id_string: link.shop_id_string, link: new_url, user: link.user, status: 'false', shop_id: link.shop_id, link_from: link.link_from, link_retry: true)
          end
        end
      end
      return
    else
      a = a.children
    end
  end

  puts page.title

  link_hash = {}
  links_array = []
  next_uri = ''
  1.step(a.count - 2, 2) do |i|
    if a[i].at('a.productImg').nil?
      puts "ad #{i}"
    else
      if filter_product(a[i], link.shop_id)
        # todo
        puts "not in shop #{i}"
      else
        link_hash[:address] = "https://" + a[i].at('a.productImg').attributes["href"].value[2..-1]
        product_link_start = link_hash[:address].index('id') + 3
        product_link_end = link_hash[:address][product_link_start..-1].index('&') - 1 + product_link_start

        product_link_id = link_hash[:address][product_link_start..product_link_end]
        unless TmallLink.where(product_link_id: product_link_id).first
          link_hash[:address] = "http://detail.tmall.com/item.htm?id=" + product_link_id.to_s
          link_hash[:product_link_id] = product_link_id
          link_hash[:user_id] = link.user_id
          link_hash[:status]  = 'false'
          link_hash[:shop_id] = link.shop_id
          links_array << link_hash.dup
        end
      end
    end
  end
  
  # next uri
  if (page.at('.ui-page-next') && page.at('.ui-page-next').attributes["href"])
    next_uri = page.at('.ui-page-next').attributes["href"].value
  else
    next_uri = ''
  end

  uri = link.link
  unless next_uri.blank?
    unless next_uri == ''
      new_url = 'https://list.tmall.com/search_product.htm' + next_uri
      puts new_url
      if ShopLink.where(link: new_url).count > 0
        puts 'old next url'
      else
        link.update_attributes(status: true, link_retry: false)
        ShopLink.create(shop_id_string: link.shop_id_string, link: new_url, user: link.user, status: 'false', shop_id: link.shop_id, link_from: link.link_from)
      end
    end
  end
  TmallLink.create(links_array)
end

namespace :shop_link_auto_check do
  desc 'check shop link automatically'
  task :check => :environment do
    2.times do
      sleep rand(15..20)
      shop_link = get_first_shop_link
      if shop_link.present?
        grasp_shop shop_link
      end
    end
  end
end
