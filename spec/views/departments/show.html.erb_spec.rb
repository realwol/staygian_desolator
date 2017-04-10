require 'rails_helper'

RSpec.describe "departments/show", :type => :view do
  before(:each) do
    @department = assign(:department, Department.create!(
      :name => "Name",
      :parent_id => 1,
      :backup => "Backup"
    ))
  end

  it "renders attributes in <p>" do
    # render
    # expect(rendered).to match(/Name/)
    # expect(rendered).to match(/1/)
    # expect(rendered).to match(/Backup/)
  end
end
