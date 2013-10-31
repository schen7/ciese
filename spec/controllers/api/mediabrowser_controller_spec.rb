require 'spec_helper'

describe Api::MediabrowserController do

  describe "GET #index" do
    let(:method) { :get }
    let(:action) { :index }
    let(:params) { }

    it_behaves_like "an api action that requires an active staff or admin user"

    context "when accessed by an authorized user" do
      let(:staff) { create(:staff) }
      before do
        controller.log_in(staff)
        get :index, format: :json
      end

      it "should render a json list of files in the media root folder" do
        data = ActiveSupport::JSON.decode(response.body)
        expect(data["data"]).to eq 'yup'
      end
    end


  end

end


