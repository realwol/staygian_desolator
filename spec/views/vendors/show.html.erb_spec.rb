require 'rails_helper'

RSpec.describe "vendors/show", :type => :view do
  before(:each) do
    @vendor = assign(:vendor, Vendor.create!(
      :name => "Name",
      :brand => nil,
      :purchase_address => "Purchase Address",
      :contact => "Contact",
      :backup => "Backup"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Purchase Address/)
    expect(rendered).to match(/Contact/)
    expect(rendered).to match(/Backup/)
  end
end
