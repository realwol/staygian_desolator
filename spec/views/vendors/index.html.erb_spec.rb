require 'rails_helper'

RSpec.describe "vendors/index", :type => :view do
  before(:each) do
    assign(:vendors, [
      Vendor.create!(
        :name => "Name",
        :brand => nil,
        :purchase_address => "Purchase Address",
        :contact => "Contact",
        :backup => "Backup"
      ),
      Vendor.create!(
        :name => "Name",
        :brand => nil,
        :purchase_address => "Purchase Address",
        :contact => "Contact",
        :backup => "Backup"
      )
    ])
  end

  it "renders a list of vendors" do
    # render
    # assert_select "tr>td", :text => "Name".to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => "Purchase Address".to_s, :count => 2
    # assert_select "tr>td", :text => "Contact".to_s, :count => 2
    # assert_select "tr>td", :text => "Backup".to_s, :count => 2
  end
end
