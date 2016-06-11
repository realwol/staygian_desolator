require 'rails_helper'

RSpec.describe "departments/index", :type => :view do
  before(:each) do
    assign(:departments, [
      Department.create!(
        :name => "Name",
        :parent_id => 1,
        :backup => "Backup"
      ),
      Department.create!(
        :name => "Name",
        :parent_id => 1,
        :backup => "Backup"
      )
    ])
  end

  it "renders a list of departments" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Backup".to_s, :count => 2
  end
end
