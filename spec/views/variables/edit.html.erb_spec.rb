require 'rails_helper'

RSpec.describe "variables/edit", :type => :view do
  before(:each) do
    @variable = assign(:variable, Variable.create!(
      :color => "MyString",
      :size => "MyString",
      :price => "MyString",
      :product => nil,
      :image_url1 => "MyText",
      :stock => "MyString"
    ))
  end

  it "renders the edit variable form" do
    # render
    # assert_select "form[action=?][method=?]", variable_path(@variable), "post" do
      # assert_select "input#variable_color[name=?]", "variable[color]"
      # assert_select "input#variable_size[name=?]", "variable[size]"
      # assert_select "input#variable_price[name=?]", "variable[price]"
      # assert_select "input#variable_product_id[name=?]", "variable[product_id]"
      # assert_select "textarea#variable_image_url1[name=?]", "variable[image_url1]"
      # assert_select "input#variable_stock[name=?]", "variable[stock]"
    # end
  end
end
