require 'rails_helper'

RSpec.describe ProductTypesController, :type => :controller do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all product_types as @product_types" do
      product_type = ProductType.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:product_types)).to eq([product_type])
    end
  end

  describe "GET show" do
    it "assigns the requested product_type as @product_type" do
      product_type = ProductType.create! valid_attributes
      get :show, {:id => product_type.to_param}, valid_session
      expect(assigns(:product_type)).to eq(product_type)
    end
  end

  describe "GET new" do
    it "assigns a new product_type as @product_type" do
      # get :new, {}, valid_session
      # expect(assigns(:product_type)).to be_a_new(ProductType)
    end
  end

  describe "GET edit" do
    it "assigns the requested product_type as @product_type" do
      product_type = ProductType.create! valid_attributes
      get :edit, {:id => product_type.to_param}, valid_session
      expect(assigns(:product_type)).to eq(product_type)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ProductType" do
        expect {
          post :create, {:product_type => valid_attributes}, valid_session
        }.to change(ProductType, :count).by(1)
      end

      it "assigns a newly created product_type as @product_type" do
        post :create, {:product_type => valid_attributes}, valid_session
        expect(assigns(:product_type)).to be_a(ProductType)
        expect(assigns(:product_type)).to be_persisted
      end

      it "redirects to the created product_type" do
        post :create, {:product_type => valid_attributes}, valid_session
        expect(response).to redirect_to(ProductType.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved product_type as @product_type" do
        post :create, {:product_type => invalid_attributes}, valid_session
        expect(assigns(:product_type)).to be_a_new(ProductType)
      end

      it "re-renders the 'new' template" do
        post :create, {:product_type => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested product_type" do
        product_type = ProductType.create! valid_attributes
        put :update, {:id => product_type.to_param, :product_type => new_attributes}, valid_session
        product_type.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested product_type as @product_type" do
        product_type = ProductType.create! valid_attributes
        put :update, {:id => product_type.to_param, :product_type => valid_attributes}, valid_session
        expect(assigns(:product_type)).to eq(product_type)
      end

      it "redirects to the product_type" do
        product_type = ProductType.create! valid_attributes
        put :update, {:id => product_type.to_param, :product_type => valid_attributes}, valid_session
        expect(response).to redirect_to(product_type)
      end
    end

    describe "with invalid params" do
      it "assigns the product_type as @product_type" do
        product_type = ProductType.create! valid_attributes
        put :update, {:id => product_type.to_param, :product_type => invalid_attributes}, valid_session
        expect(assigns(:product_type)).to eq(product_type)
      end

      it "re-renders the 'edit' template" do
        product_type = ProductType.create! valid_attributes
        put :update, {:id => product_type.to_param, :product_type => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested product_type" do
      product_type = ProductType.create! valid_attributes
      expect {
        delete :destroy, {:id => product_type.to_param}, valid_session
      }.to change(ProductType, :count).by(-1)
    end

    it "redirects to the product_types list" do
      product_type = ProductType.create! valid_attributes
      delete :destroy, {:id => product_type.to_param}, valid_session
      expect(response).to redirect_to(product_types_url)
    end
  end

end
