require 'rails_helper'

RSpec.describe "products/show", :type => :view do
  before(:each) do
    @product = assign(:product, Product.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Sku/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Product Number/)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Brand/)
    expect(rendered).to match(/Price/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Product From/)
    expect(rendered).to match(/MyText/)
  end
end
