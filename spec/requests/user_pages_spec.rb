require 'spec_helper'

describe "UserPages" do
  describe "list users" do
    let!(:users) { create_list(:user, 2) }
    before { visit users_path }

    it "should list all the users and have an appropriate header and title" do
      expect(page).to have_title(full_title('Users'))
      expect(page).to have_selector('h1', 'Users')
      expect(page).to have_selector('table#users')
      expect(page.all('table tbody tr').count).to eq 2
      users.each do |user|
        expect(page).to have_content(user.username)
        expect(page).to have_content(user.email)
        expect(page).to have_link(user.username, href: user_path(user.id))
      end
    end
  end
  
  context "when user is active" do
	let!(:user) { create(:user) }
    before { visit users_path }
	
	subject{ page }

	it{ should have_link('deactivate', href: deactivate_user_path(user.id)) }
  end
  
  context "when user is not active" do
	let!(:user) { create(:user, active: false) }
    before { visit users_path }
	
	subject{ page }

	it{ should have_link('activate', href: activate_user_path(user.id)) }
  end
  
  describe "user info" do
	let!(:user) { create(:user) }
    before { visit user_path(user) }
	
	subject{ page }

    it { should have_content(user.username) }
    it { should have_content(user.email) }
	it { should have_content(user.admin) }
	it { should have_content(user.staff) }
	it { should have_content(user.active) }
	it { should have_link('edit', href: edit_user_path(user))}
  end
  
  describe "edit" do
    let!(:user) { create(:user) }
    before { visit edit_user_path(user) }
	
	subject{ page }

    it { should have_title("Edit user") }
    
    context "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end
	
	context "with valid information" do
      let(:new_username)  { "NewUsername" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Username",         with: new_username
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
		check "Admin"
		check "Staff"
		check "Active"
        click_button "Save changes"
      end

      specify { expect(user.reload.username).to eq new_username }
      specify { expect(user.reload.email).to eq new_email }
    end
	
  end
end
