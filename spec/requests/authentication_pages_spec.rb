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
        before { login(user) }

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
    describe "for non-logged-in users" do
      let(:user) { create(:user) }
      
      context "when attempting to visit a protected page before loggin in" do
        before do
          visit edit_user_path(user)
          login(user)
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
    
    context "logged-in users attempt to edit other user" do
      let(:user) { create(:user) }
      let(:wrong_user) { create(:user) }
      before { login(user) }
      
      context "visiting user edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title(full_title('Edit User')) }
      end
      
      context "submitting a PATCH request to the user update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(login_path) }
      end
    end
    
    describe "activate/deactivate users" do
      context "as non-admin users" do
        let(:user) { create(:user) }
        let(:non_admin) { create(:user) }
        before do 
          login(non_admin)
          visit deactivate_user_path(user)
        end
        #specify { expect(current_path).to eq root_path }
        it { should have_text("You don't have access to this section.") }
      end
      
      context "as admin users" do
        let(:user) { create(:user) }
        let(:admin_user) { create(:admin) }
        before do
          login(admin_user)
          visit deactivate_user_path(user)
        end
        #specify { expect(current_path).to eq users_path }
        it { should have_link("activate") }
      end
    end
  end
end
