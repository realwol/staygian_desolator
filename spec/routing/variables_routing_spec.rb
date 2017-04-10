require "rails_helper"

RSpec.describe VariablesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/variables").to route_to("variables#index")
    end

    it "routes to #new" do
      # expect(:get => "/variables/new").to route_to("variables#new")
    end

    it "routes to #show" do
      # expect(:get => "/variables/1").to route_to("variables#show", :id => "1")
    end

    it "routes to #edit" do
      # expect(:get => "/variables/1/edit").to route_to("variables#edit", :id => "1")
    end

    it "routes to #create" do
      # expect(:post => "/variables").to route_to("variables#create")
    end

    it "routes to #update" do
      # expect(:put => "/variables/1").to route_to("variables#update", :id => "1")
    end

    it "routes to #destroy" do
      # expect(:delete => "/variables/1").to route_to("variables#destroy", :id => "1")
    end

  end
end
