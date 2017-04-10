require 'rails_helper'

RSpec.describe "variables/index", :type => :view do
  before(:each) do
    assign(:variables, [
      Variable.create!(
        :color => "Color",
        :size => "Size",
        :price => "Price",
        :product => nil,
        :image_url1 => "MyText",
        :stock => "Stock"
      ),
      Variable.create!(
        :color => "Color",
        :size => "Size",
        :price => "Price",
        :product => nil,
        :image_url1 => "MyText",
        :stock => "Stock"
      )
    ])
  end

  it "renders a list of variables" do
    # render
    # assert_select "tr>td", :text => "Color".to_s, :count => 2
    # assert_select "tr>td", :text => "Size".to_s, :count => 2
    # assert_select "tr>td", :text => "Price".to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # assert_select "tr>td", :text => "Stock".to_s, :count => 2
  end
end
