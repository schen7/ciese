require 'spec_helper'

describe "AuthenticationPages" do

  subject { page }

  describe "login page" do
    before { visit login_path }

    describe "page structure" do
      it "should have 'Log In' in the title and main header" do
        expect(page).to have_title(full_title('Log In'))
        expect(page).to have_selector('h1', text: 'Log In')
      end
    end

    context "when login form is filled out and submitted" do
      context "with invalid info" do
        before { click_button "Log In" }

        it { should have_selector('div.alert-box.alert', text: "Your username/password combination is not correct.") }
      end

      context "with valid info" do
        let(:user) { create(:user) }
        before do
          fill_in "Username", with: user.username
          fill_in "Password", with: user.password
          click_button "Log In"
        end

        it "should redirect to root and show 'Log Out' link" do
          expect(current_path).to eq root_path
          expect(page).to have_link("Log Out")
        end

        context "when followed by logout" do
          before { click_link "Log Out" }

          it "should redirect to root and show 'Log In' link" do
            expect(current_path).to eq root_path
            expect(page).to have_link("Log In")
          end
        end
      end
    end
  end
end
