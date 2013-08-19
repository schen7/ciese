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
end
