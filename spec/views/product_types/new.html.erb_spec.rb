require 'rails_helper'

RSpec.describe "product_types/new", :type => :view do
  before(:each) do
    assign(:product_type, ProductType.new(
      :name => "MyString",
      :father_node => "MyString"
    ))
  end

  it "renders new product_type form" do
    render

    assert_select "form[action=?][method=?]", product_types_path, "post" do

      assert_select "input#product_type_name[name=?]", "product_type[name]"

      assert_select "input#product_type_father_node[name=?]", "product_type[father_node]"
    end
  end
end
