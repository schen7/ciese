require 'spec_helper'

describe UsersController do

  describe "PUT #update" do
    let(:method) { :put }
    let(:action) { :update }
    let(:params) { {id: 1} }

    it_behaves_like "an action that requires an active admin user"
  end

  describe "PUT #activate" do
    let(:method) { :put }
    let(:action) { :activate }
    let(:params) { {id: 1} }

    it_behaves_like "an action that requires an active admin user"
  end

  describe "PUT #deactivate" do
    let(:method) { :put }
    let(:action) { :deactivate }
    let(:params) { {id: 1} }

    it_behaves_like "an action that requires an active admin user"
  end
end
