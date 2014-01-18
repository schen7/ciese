require 'spec_helper'

describe Api::FormsController do

  describe "POST #create" do
    let(:method) { :post }
    let(:action) { :create }
    let(:params) { {} }

    it_behaves_like "an api action that requires an active staff or admin user"
  end

  describe "GET #show" do
    let(:method) { :get }
    let(:action) { :show }
    let(:params) { {id: 1} }

    it_behaves_like "an api action that requires an active staff or admin user"
  end

  describe "PUT #update" do
    let(:method) { :put }
    let(:action) { :update }
    let(:params) { {id: 1} }

    it_behaves_like "an api action that requires an active staff or admin user"
  end

  describe "POST #destroy" do
    let(:method) { :post }
    let(:action) { :update }
    let(:params) { {id: 1} }

    it_behaves_like "an api action that requires an active staff or admin user"
  end

end


