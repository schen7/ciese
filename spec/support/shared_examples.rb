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

shared_examples "a page that rejects a regular user" do
  context "when visited by a regular user" do
    let(:user) { create(:user) }
    before { log_in_and_visit(user, path) }

    it { should have_content(not_authorized_message) }
  end
end

shared_examples "a page that rejects a non-active regular user" do
  context "when visited by a non-active regular user" do
    let(:user) { create(:user, active: false) }
    before { log_in_and_visit(user, path) }

    it { should have_content(not_authorized_message) }
  end
end

shared_examples "a page that rejects a staff user" do
  context "when visited by a staff user" do
    let(:user) { create(:staff) }
    before { log_in_and_visit(user, path) }

    it { should have_content(not_authorized_message) }
  end
end

shared_examples "a page that rejects a non-active staff user" do
  context "when visited by a non-active staff user" do
    let(:user) { create(:staff, active: false) }
    before { log_in_and_visit(user, path) }

    it { should have_content(not_authorized_message) }
  end
end

shared_examples "a page that rejects an admin user" do
  context "when visited by an admin user" do
    let(:user) { create(:admin) }
    before { log_in_and_visit(user, path) }

    it { should have_content(not_authorized_message) }
  end
end

shared_examples "a page that rejects a non-active admin user" do
  context "when visited by a non-active admin user" do
    let(:user) { create(:admin, active: false) }
    before { log_in_and_visit(user, path) }

    it { should have_content(not_authorized_message) }
  end
end
=begin
shared_examples "a page that requires an active regular user" do
  it_behaves_like "a page that requires a logged-in user"
  it_behaves_like "a page that rejects a non-active regular user"
  it_behaves_like "a page that rejects a non-active staff user"
  it_behaves_like "a page that rejects a non-active admin user"
end
=end
shared_examples "a page that requires an active staff or admin user" do
  it_behaves_like "a page that requires a logged-in user"
  it_behaves_like "a page that rejects a regular user"
  it_behaves_like "a page that rejects a non-active staff user"
  it_behaves_like "a page that rejects a non-active admin user"
end

shared_examples "a page that requires an active admin user" do
  it_behaves_like "a page that requires a logged-in user"
  it_behaves_like "a page that rejects a regular user"
  it_behaves_like "a page that rejects a staff user"
  it_behaves_like "a page that rejects a non-active admin user"
end


# Controller shared examples

shared_examples "an action that requires a logged-in user" do
  context "when attempted by a logged-out user" do
    before { send(method, action, params) }

    it { should redirect_to(login_path) }
  end
end

shared_examples "an action that rejects a regular user" do
  context "when attempted by a regular user" do
    before do
      controller.log_in(create(:user))
      send(method, action, params)
    end

    it { should render_template("static_pages/403.html") }
  end
end

shared_examples "an action that rejects a non-active regular user" do
  context "when attempted by a non-active regular user" do
    before do
      controller.log_in(create(:user, active: false))
      send(method, action, params)
    end

    it { should render_template("static_pages/403.html") }
  end
end

shared_examples "an action that rejects a staff user" do
  context "when attempted by a staff user" do
    before do
      controller.log_in(create(:staff))
      send(method, action, params)
    end

    it { should render_template("static_pages/403.html") }
  end
end

shared_examples "an action that rejects a non-active staff user" do
  context "when attempted by a non-active staff user" do
    before do
      controller.log_in(create(:staff, active: false))
      send(method, action, params)
    end

    it { should render_template("static_pages/403.html") }
  end
end

shared_examples "an action that rejects an admin user" do
  context "when attempted by an admin user" do
    before do
      controller.log_in(create(:admin))
      send(method, action, params)
    end

    it { should render_template("static_pages/403.html") }
  end
end

shared_examples "an action that rejects a non-active admin user" do
  context "when attempted by a non-active admin user" do
    before do
      controller.log_in(create(:admin, active: false))
      send(method, action, params)
    end

    it { should render_template("static_pages/403.html") }
  end
end
=begin
shared_examples "an action that requires an active regular user" do
  it_behaves_like "an action that requires a logged-in user"
  it_behaves_like "an action that rejects a non-active regular user"
  it_behaves_like "an action that rejects a non-active staff user"
  it_behaves_like "an action that rejects a non-active admin user"
end
=end
shared_examples "an action that requires an active staff or admin user" do
  it_behaves_like "an action that requires a logged-in user"
  it_behaves_like "an action that rejects a regular user"
  it_behaves_like "an action that rejects a non-active staff user"
  it_behaves_like "an action that rejects a non-active admin user"
end

shared_examples "an action that requires an active admin user" do
  it_behaves_like "an action that requires a logged-in user"
  it_behaves_like "an action that rejects a regular user"
  it_behaves_like "an action that rejects a staff user"
  it_behaves_like "an action that rejects a non-active admin user"
end
