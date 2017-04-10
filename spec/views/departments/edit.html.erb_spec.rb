require 'rails_helper'

RSpec.describe "departments/edit", :type => :view do
  before(:each) do
    @department = assign(:department, Department.create!(
      :name => "MyString",
      :parent_id => 1,
      :backup => "MyString"
    ))
  end

  it "renders the edit department form" do
    # render
    # assert_select "form[action=?][method=?]", department_path(@department), "post" do
      # assert_select "input#department_name[name=?]", "department[name]"
      # assert_select "input#department_parent_id[name=?]", "department[parent_id]"
      # assert_select "input#department_backup[name=?]", "department[backup]"
    # end
  end
end
