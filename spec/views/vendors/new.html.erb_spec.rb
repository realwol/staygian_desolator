require 'rails_helper'

RSpec.describe "vendors/new", :type => :view do
  before(:each) do
    assign(:vendor, Vendor.new(
      :name => "MyString",
      :brand => nil,
      :purchase_address => "MyString",
      :contact => "MyString",
      :backup => "MyString"
    ))
  end

  it "renders new vendor form" do
    render

    assert_select "form[action=?][method=?]", vendors_path, "post" do

      assert_select "input#vendor_name[name=?]", "vendor[name]"

      assert_select "input#vendor_brand_id[name=?]", "vendor[brand_id]"

      assert_select "input#vendor_purchase_address[name=?]", "vendor[purchase_address]"

      assert_select "input#vendor_contact[name=?]", "vendor[contact]"

      assert_select "input#vendor_backup[name=?]", "vendor[backup]"
    end
  end
end
