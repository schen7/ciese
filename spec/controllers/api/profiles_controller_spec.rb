require 'spec_helper'

describe Api::ProfilesController do

  describe "GET #index" do
    let(:method) { :get }
    let(:action) { :index }
    let(:params) { }

    it_behaves_like "an action that requires an active staff or admin user"

    context "when accessed by an authorized user" do
      let(:staff) { create(:staff) }
      let!(:profiles) { create_list(:profile_with_activities, 2) }
      before do
        controller.log_in(staff)
        get :index
      end

      it "should render a json list of profiles" do
        data = ActiveSupport::JSON.decode(response.body)
        expect(data.keys).to eq ["profiles", "pages"]
        expect(data["profiles"].length).to eq 2
        expect(data["pages"]).to eq 1
      end
    end
  end

  describe "POST #create" do
    let(:method) { :post }
    let(:action) { :create }
    let(:params) { }

    it_behaves_like "an action that requires an active staff or admin user"
  end

  describe "GET #show" do
    let(:method) { :get }
    let(:action) { :show }
    let(:params) { {id: 1} }

    it_behaves_like "an action that requires an active staff or admin user"
  end

  describe "PUT #update" do
    let(:method) { :put }
    let(:action) { :update }
    let(:params) { {id: 1} }

    it_behaves_like "an action that requires an active staff or admin user"
  end

end
