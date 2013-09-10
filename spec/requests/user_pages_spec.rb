require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "list users page" do
    let(:path) { users_path }

    it_behaves_like "a page that requires an admin user"

    context "when visited by an admin user" do
      let(:admin) { create(:admin) }
    
      it "should list all the users and have an appropriate header and title" do
        users = create_list(:user, 2)
        log_in_and_visit(admin, path)
        expect(page).to have_title(full_title('Users'))
        expect(page).to have_selector('h1', 'Users')
        expect(page).to have_selector('table#users')
        expect(page.all('table tbody tr').count).to eq 3
        users.each do |user|
          expect(page).to have_content(user.username)
          expect(page).to have_content(user.email)
          expect(page).to have_link(user.username, href: user_path(user.id))
        end
      end

      context "when user is active" do
        let!(:user) { create(:user) }
        before { log_in_and_visit(admin, path) }
        
        it { should have_link('deactivate', href: deactivate_user_path(user.id)) }
      end
      
      context "when user is not active" do
        let!(:user) { create(:user, active: false) }
        before { log_in_and_visit(admin, path) }
      
        it { should have_link('activate', href: activate_user_path(user.id)) }
      end
    end
  end
  
  describe "show user page" do
    let(:user) { create(:user) }
    let(:path) { user_path(user) }

    it_behaves_like "a page that requires an admin user"

    context "when visited by an admin user" do
      let(:admin) { create(:admin) }
      before { log_in_and_visit(admin, path) }

      it "should have title, header, list appropriate user info, and have an edit link" do
        expect(page).to have_title(full_title('User Info'))
        expect(page).to have_selector('h1', 'User Info')
        expect(page).to have_content(user.username)
        expect(page).to have_content(user.email)
        expect(page).to have_content(user.admin)
        expect(page).to have_content(user.staff)
        expect(page).to have_content(user.active)
        expect(page).to have_link('Edit', href: edit_user_path(user))
      end
    end
  end
  
  describe "edit user page" do
    let(:user) { create(:user) }
    let(:path) { edit_user_path(user) }

    it_behaves_like "a page that requires an admin user"

    context "when visited by an admin user" do
      let(:admin) { create(:admin) }
      before { log_in_and_visit(admin, path) }
  
      it "should have title, header, and editing form" do
        expect(page).to have_title(full_title("Edit User"))
        expect(page).to have_selector('h1', 'Edit User')
        expect(page).to have_selector('form')
      end

      context "when the form is submitted" do

        context "without any changes" do
          before { click_button "Save" }

          it { should have_selector('.alert-success', text: 'Profile updated.') }
        end

        context "with invalid information" do
          before do
            fill_in "Username", with: ''
            fill_in "Email", with: ''
            click_button "Save"
          end

          it { should have_selector('.alert-error', text: 'error') }
        end
      
        context "with valid information" do
          before do
            fill_in "Username", with: 'new.username'
            fill_in "Email", with: 'new.email@none.com'
            fill_in "Password", with: 'new_password123'
            fill_in "Confirm Password", with: 'new_password123'
            check "Admin"
            check "Staff"
            check "Active"
            click_button "Save"
          end

          it "should be successful" do
            expect(page).to have_selector('.alert-success', text: 'Profile updated.')
            expect(page).to have_content('new.username')
            expect(page).to have_content('new.email@none.com')
          end
        end
      end
    end
  end
end
