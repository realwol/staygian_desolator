require 'selenium-webdriver'

namespace :shop_link do
  desc 'check_shop_link'
  task :check	=> :environment do
  	# Check table shop_links
    # sleep (0..20).to_a.sample
    run = true
    while run
    	shop_links = get_shop_links
    	if shop_links.present?
        a = Time.now
        grasp_link shop_links
        puts '========='
        puts Time.now - a
        run = true
      else
        puts 'no shop'
        run = false
      end
  	end
  end
end

def get_shop_links
	ShopLink.un_grasp
end

def grasp_link shop_links
  driver = Selenium::WebDriver.for :firefox
  driver.get shop_links.first.link

  # make the login
  binding.pry

  shop_links.each do |shop_link|
    driver.get shop_link.link

    links_array, link_hash, page_number = [], {}, 0

    loop do
      tmp_page_number = driver.find_element(class: 'ui-page-cur').text().to_i
      if page_number < tmp_page_number
        page_number = tmp_page_number
      else
        break
      end
      images = driver.find_elements(class: 'productImg')
      images.each do |link|
        link_hash[:address] = link.attribute('href')
        # link_hash[:product_link_id] = product_link_id
        link_hash[:user_id] = shop_link.user_id
        link_hash[:status]  = 'false'
        link_hash[:shop_id]  = shop_link.shop_id
        links_array << link_hash.dup
      end
      # binding.pry
      begin
        next_url =  driver.find_element(class: 'ui-page-next').attribute('href')
      rescue
        puts driver.current_url
        return
      end

      if next_url
        driver.get next_url unless next_url.nil?
        sleep 3
      else
        break
      end
    end
    TmallLink.create(links_array)
    shop_link.update_attributes(status: true)
  end
end

# def grasp_link shop_link
#     links_array = []
#     link_hash = {}
#     next_uri = ''
#     # agent = Mechanize.new
#     uri = shop_link.link
#     redirect_to root_path if uri.blank?

#     agent = UserAgents.rand()
#     page = Nokogiri::HTML(open(uri, 'User-Agent' => agent, :allow_redirections => :all ))
#     # headers = {}
#     # headers['cookie'] = 'cna=b91vDALZiDECASQuwCMFpCOV; _med=dw:1440&dh:900&pw:1440&ph:900&ist:0; cq=ccp%3D0; _tb_token_=O3sgEgNF6d2F; uc1=cookie15=VFC%2FuZ9ayeYq2g%3D%3D&existShop=false; uc3=nk2=EULlRyv1gA%3D%3D&id2=WvELDNoWjz8c&vt3=F8dAScL3rXwCNhi3MZc%3D&lg2=V32FPkk%2Fw0dUvg%3D%3D; lgc=realwol; tracknick=realwol; cookie2=1ce16ecbd934f991a66db258d14a13c0; cookie1=UUiHXHY94MibArpt6eDcP5sl%2BJqgt1sbu3Vk8cKBCUw%3D; unb=910047907; skt=e6ba33fea1d46b89; t=106c27ff1c8c8e8f5ff5673474978132; _l_g_=Ug%3D%3D; _nk_=realwol; cookie17=WvELDNoWjz8c; login=true; l=AgUFd3dio7rrI2m4sK7nGty2lUs/wrlU; isg=4AA74E11B09DA670670C96FE237383CF'
#     # page = agent.get(uri)
#       if page.at('#J_ItemList')
#         a = page.at('#J_ItemList').children
#       else
#         puts page.title
#         return
#       end

#       1.step(a.count - 2,2) do |i|
#         link_hash[:address] = "https://" + a[i].at('a.productImg').attributes["href"].value[2..-1]
#         product_link_start = link_hash[:address].index('id') + 3
#         product_link_end = link_hash[:address][product_link_start..-1].index('&') - 1 + product_link_start

#         product_link_id = link_hash[:address][product_link_start..product_link_end]
#         unless TmallLink.where(product_link_id: product_link_id).first
#           link_hash[:address] = "http://detail.tmall.com/item.htm?id=" + product_link_id.to_s
#           link_hash[:product_link_id] = product_link_id
#           link_hash[:user_id] = shop_link.user_id
#           link_hash[:status]  = 'false'
#           link_hash[:shop_id]  = (shop_link.shop_id || params[:product][:shop_id])
#           links_array << link_hash.dup
#         end
#       end
#       if (page.at('.ui-page-next') && page.at('.ui-page-next').attributes["href"])
#         next_uri = page.at('.ui-page-next').attributes["href"].value
#       else
#         next_uri = ''
#       end

#     unless next_uri.blank?
#       unless next_uri == ''
#         uri = uri[0..(uri.index('?')-1)] + next_uri
#         ShopLink.create(shop_id_string: shop_link.shop_id_string, link: uri, user: shop_link.user, status: 'false', shop_id: shop_link.shop_id)
#       end
#     end
#     TmallLink.create(links_array)
# end
