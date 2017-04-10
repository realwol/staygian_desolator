require 'rails_helper'

RSpec.describe "departments/new", :type => :view do
  before(:each) do
    assign(:department, Department.new(
      :name => "MyString",
      :parent_id => 1,
      :backup => "MyString"
    ))
  end

  it "renders new department form" do
    # render
    # assert_select "form[action=?][method=?]", departments_path, "post" do
    #   assert_select "input#department_name[name=?]", "department[name]"
    #   assert_select "input#department_parent_id[name=?]", "department[parent_id]"
    #   assert_select "input#department_backup[name=?]", "department[backup]"
    # end
  end
end
