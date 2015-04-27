require 'rails_helper'

RSpec.describe "products/index", :type => :view do
  before(:each) do
    assign(:products, [
      Product.create!(
        :product_type => nil,
        :title => "MyText",
        :sku => "Sku",
        :sku_number => 1,
        :product_number => "Product Number",
        :user => nil,
        :origin_address => "MyText",
        :desc1 => "MyText",
        :brand => "Brand",
        :price => "Price",
        :on_sale => false,
        :translate_status => false,
        :product_from => "Product From",
        :details => "MyText"
      ),
      Product.create!(
        :product_type => nil,
        :title => "MyText",
        :sku => "Sku",
        :sku_number => 1,
        :product_number => "Product Number",
        :user => nil,
        :origin_address => "MyText",
        :desc1 => "MyText",
        :brand => "Brand",
        :price => "Price",
        :on_sale => false,
        :translate_status => false,
        :product_from => "Product From",
        :details => "MyText"
      )
    ])
  end

  it "renders a list of products" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Sku".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Product Number".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Brand".to_s, :count => 2
    assert_select "tr>td", :text => "Price".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Product From".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
