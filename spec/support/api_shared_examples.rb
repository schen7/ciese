# API Controller shared examples

shared_examples "an api action that requires a logged-in user" do
  context "when attempted by a logged-out user" do
    before { send(method, action, params.merge({format: :json})) }

    it "should result in a 403 error with an appropriate json message" do
      expect(response.code).to eq "403"
      data = ActiveSupport::JSON.decode(response.body)
      expect(data).to eq({"error" => "Login required."})
    end
  end
end

shared_examples "an api action that rejects a regular user" do
  context "when attempted by a regular user" do
    before do
      controller.log_in(create(:user))
      send(method, action, params.merge({format: :json}))
    end

    it "should result in a 403 error with an appropriate json message" do
      expect(response.code).to eq "403"
      data = ActiveSupport::JSON.decode(response.body)
      expect(data).to eq({"error" => "Not authorized."})
    end
  end
end

shared_examples "an api action that rejects a non-active regular user" do
  context "when attempted by a non-active regular user" do
    before do
      controller.log_in(create(:user, active: false))
      send(method, action, params.merge({format: :json}))
    end

    it "should result in a 403 error with an appropriate json message" do
      expect(response.code).to eq "403"
      data = ActiveSupport::JSON.decode(response.body)
      expect(data).to eq({"error" => "Not authorized."})
    end
  end
end

shared_examples "an api action that rejects a staff user" do
  context "when attempted by a staff user" do
    before do
      controller.log_in(create(:staff))
      send(method, action, params.merge({format: :json}))
    end

    it "should result in a 403 error with an appropriate json message" do
      expect(response.code).to eq "403"
      data = ActiveSupport::JSON.decode(response.body)
      expect(data).to eq({"error" => "Not authorized."})
    end
  end
end

shared_examples "an api action that rejects a non-active staff user" do
  context "when attempted by a non-active staff user" do
    before do
      controller.log_in(create(:staff, active: false))
      send(method, action, params.merge({format: :json}))
    end

    it "should result in a 403 error with an appropriate json message" do
      expect(response.code).to eq "403"
      data = ActiveSupport::JSON.decode(response.body)
      expect(data).to eq({"error" => "Not authorized."})
    end
  end
end

shared_examples "an api action that rejects an admin user" do
  context "when attempted by an admin user" do
    before do
      controller.log_in(create(:admin))
      send(method, action, params.merge({format: :json}))
    end

    it "should result in a 403 error with an appropriate json message" do
      expect(response.code).to eq "403"
      data = ActiveSupport::JSON.decode(response.body)
      expect(data).to eq({"error" => "Not authorized."})
    end
  end
end

shared_examples "an api action that rejects a non-active admin user" do
  context "when attempted by a non-active admin user" do
    before do
      controller.log_in(create(:admin, active: false))
      send(method, action, params.merge({format: :json}))
    end

    it "should result in a 403 error with an appropriate json message" do
      expect(response.code).to eq "403"
      data = ActiveSupport::JSON.decode(response.body)
      expect(data).to eq({"error" => "Not authorized."})
    end
  end
end

shared_examples "an api action that requires an active staff or admin user" do
  it_behaves_like "an api action that requires a logged-in user"
  it_behaves_like "an api action that rejects a regular user"
  it_behaves_like "an api action that rejects a non-active staff user"
  it_behaves_like "an api action that rejects a non-active admin user"
end

shared_examples "an api action that requires an active admin user" do
  it_behaves_like "an api action that requires a logged-in user"
  it_behaves_like "an api action that rejects a regular user"
  it_behaves_like "an api action that rejects a staff user"
  it_behaves_like "an api action that rejects a non-active admin user"
end
