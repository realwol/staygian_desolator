# do not use. 2016-06-01.
require 'selenium-webdriver'

namespace :read_tmall_links do
  desc 'read tmall_links'
  task :start => :environment do
    shop_link = get_first_shop_link
    if shop_link
      grasp_list shop_link
      save_links
    end
  end
end

def get_first_shop_link
  ShopLink.un_grasp.first
end

def save_links
    links = File.open('public/tmall_links.txt', 'r')
    count = 1
    shop_id = '1'
    user_id = '1'
    links_array, link_hash = [], {}
    while line = links.gets
          link_hash[:address] = line
          link_hash[:user_id] = user_id
          link_hash[:status]  = 'false'
          link_hash[:shop_id]  = shop_id
          links_array << link_hash.dup
    end
    TmallLink.create(links_array)
end

def grasp_list link
  driver = Selenium::WebDriver.for :firefox
  driver.get link

  # make the login
  list = File.new("public/tmall_links.txt",'w')

  loop do
    next_url =  driver.find_element(class: 'ui-page-next').attribute('href')
    images = driver.find_elements(class: 'productImg')
    images.each do |link|
      list.puts link.attribute('href')
    end
    url = next_url
    driver.get url unless next_url.nil?
    break if next_url.nil?
    sleep 5
  end
  list.close
end
