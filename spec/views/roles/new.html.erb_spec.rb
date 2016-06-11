require 'rails_helper'

RSpec.describe "roles/new", :type => :view do
  before(:each) do
    assign(:role, Role.new(
      :name => "MyString",
      :parent_id => 1
    ))
  end

  it "renders new role form" do
    render

    assert_select "form[action=?][method=?]", roles_path, "post" do

      assert_select "input#role_name[name=?]", "role[name]"

      assert_select "input#role_parent_id[name=?]", "role[parent_id]"
    end
  end
end
