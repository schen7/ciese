# Request shared examples

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

  context "when visited by an non-active admin user " do
    let(:non_active_admin) { create(:admin, active: false) }
    before { log_in_and_visit(non_active_admin, path) }

    it { should have_content(not_authorized_message) }
  end
end


# Controller shared examples

shared_examples "an action that requires a logged-in user" do |method, action, params|
  context "when attempted by a logged-out user" do
    before { send(method, action, params) }

    it { should redirect_to(login_path) }
  end
end

shared_examples "an action that requires an admin user" do |method, action, params|
  it_behaves_like "an action that requires a logged-in user", method, action, params

  context "when attempted by a non-admin user" do
    before do
      controller.log_in(create(:user))
      send(method, action, params)
    end

    it { should render_template("static_pages/403.html") }
  end

  context "when attempted by a non-active admin user" do
    before do
      controller.log_in(create(:admin, active: false))
      send(method, action, params)
    end

    it { should render_template("static_pages/403.html") }
  end
end
