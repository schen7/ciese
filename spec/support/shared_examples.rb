shared_examples "a page that requires a logged-in user" do
  context "when visited by a logged-out user" do
    before { visit path }

    specify { expect(current_path).to eq login_path }

    context "when user then logs in" do
      let(:temp_user) { create(:user) }
      before do
        fill_in "Username", with: temp_user.username
        fill_in "Password", with: temp_user.password
        click_button "Log In"
      end

      specify { expect(current_path).to eq path }
    end
  end
end

shared_examples "a page that requires an admin user" do
  it_behaves_like "a page that requires a logged-in user"

  context "when visited by an non-admin user" do
    let(:non_admin) { create(:user) }
    before { log_in_and_visit(non_admin, path) }

    it { should have_content(not_authorized_message) }
  end
end
