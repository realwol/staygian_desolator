require 'rails_helper'

RSpec.describe "brands/index", :type => :view do
  before(:each) do
    assign(:brands, [
      Brand.create!(
        :name => "Name",
        :english_name => "English Name",
        :status => "Status"
      ),
      Brand.create!(
        :name => "Name",
        :english_name => "English Name",
        :status => "Status"
      )
    ])
  end

  it "renders a list of brands" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "English Name".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
