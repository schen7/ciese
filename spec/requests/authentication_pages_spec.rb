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

        it { should have_selector('div.alert.alert-error', text: "Your username/password combination is not correct.") }
      end

      context "with valid info" do
        let(:user) { create(:user) }
        before { log_in(user) }

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
  
  describe "authorization" do
    context "for non-signed-in users" do
      let(:user) { create(:user) }
      
      context "when attempting to visit a protected page before loggin in" do
        before do
          visit edit_user_path(user)
          log_in(user)
        end
        
        context "after signing in" do
          it "should be taken back to the desired page" do
            expect(page).to have_title(full_title('Edit User'))
          end
        end
      end
        
      context "visiting the edit page" do
        before { visit edit_user_path(user) }
        it { should have_title(full_title('Log In')) }
      end
        
      context "submiting to the update action" do
        before { patch user_path(user) }
        specify { expect(response).to redirect_to(login_path) }
      end
      
      context "list all users page" do
        before { visit users_path }
        it { should have_title(full_title('Log In')) }
      end
    end
    
    context "attempting to edit as wrong user" do
      let(:user) { create(:user) }
      let(:wrong_user) { create(:user, email: "wrong_user@none.com") }
      before { log_in(user) }
      
      context "visiting user edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title(full_title('Edit User')) }
      end
      
      context "submitting a PATCH request to the user update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(login_path) }
      end
      
    end
  end
end
