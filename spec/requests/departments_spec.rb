require 'rails_helper'

RSpec.describe "Departments", :type => :request do
  describe "GET /departments" do
    it "works! (now write some real specs)" do
      get departments_path
      expect(response.status).to be(200)
    end
  end
end
