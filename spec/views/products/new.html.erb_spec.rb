require 'rails_helper'

RSpec.describe "products/new", :type => :view do
  before(:each) do
    assign(:product, Product.new(
      :product_type => nil,
      :title => "MyText",
      :sku => "MyString",
      :sku_number => 1,
      :product_number => "MyString",
      :user => nil,
      :origin_address => "MyText",
      :desc1 => "MyText",
      :brand => "MyString",
      :price => "MyString",
      :on_sale => false,
      :translate_status => false,
      :product_from => "MyString",
      :details => "MyText"
    ))
  end

  # it "renders new product form" do
    # render
    # assert_select "form[action=?][method=?]", products_path, "post" do
    #   assert_select "input#product_product_type_id[name=?]", "product[product_type_id]"
    #   assert_select "textarea#product_title[name=?]", "product[title]"
    #   assert_select "input#product_sku[name=?]", "product[sku]"
    #   assert_select "input#product_sku_number[name=?]", "product[sku_number]"
    #   assert_select "input#product_product_number[name=?]", "product[product_number]"
    #   assert_select "input#product_user_id[name=?]", "product[user_id]"
    #   assert_select "textarea#product_origin_address[name=?]", "product[origin_address]"
    #   assert_select "textarea#product_desc1[name=?]", "product[desc1]"
    #   assert_select "input#product_brand[name=?]", "product[brand]"
    #   assert_select "input#product_price[name=?]", "product[price]"
    #   assert_select "input#product_on_sale[name=?]", "product[on_sale]"
    #   assert_select "input#product_translate_status[name=?]", "product[translate_status]"
    #   assert_select "input#product_product_from[name=?]", "product[product_from]"
    #   assert_select "textarea#product_details[name=?]", "product[details]"
    # end
  # end
end
