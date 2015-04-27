require 'rails_helper'

RSpec.describe "variables/show", :type => :view do
  before(:each) do
    @variable = assign(:variable, Variable.create!(
      :color => "Color",
      :size => "Size",
      :price => "Price",
      :product => nil,
      :image_url1 => "MyText",
      :stock => "Stock"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Color/)
    expect(rendered).to match(/Size/)
    expect(rendered).to match(/Price/)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Stock/)
  end
end
