require 'rails_helper'

RSpec.describe "brands/new", :type => :view do
  before(:each) do
    assign(:brand, Brand.new(
      :name => "MyString",
      :english_name => "MyString",
      :status => "MyString"
    ))
  end

  it "renders new brand form" do
    render

    assert_select "form[action=?][method=?]", brands_path, "post" do

      assert_select "input#brand_name[name=?]", "brand[name]"

      assert_select "input#brand_english_name[name=?]", "brand[english_name]"

      assert_select "input#brand_status[name=?]", "brand[status]"
    end
  end
end
