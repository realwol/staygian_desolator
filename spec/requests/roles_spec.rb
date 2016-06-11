require 'rails_helper'

RSpec.describe "Roles", :type => :request do
  describe "GET /roles" do
    it "works! (now write some real specs)" do
      get roles_path
      expect(response.status).to be(200)
    end
  end
end
