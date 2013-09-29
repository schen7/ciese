require 'spec_helper'

describe "ProfilePages" do

  subject { page }

  describe "index page" do
    let(:path) { admin_profiles_path }

    it_behaves_like "a page that requires an active staff or admin user"

    context "when visited by an authorized user" do
      let(:user) { create(:staff) }
      before { log_in_and_visit(user, path) }

      it "should render the angular app" do
        expect(page).to have_content('CIESE Participant Profiles')
      end
    end
  end
end
