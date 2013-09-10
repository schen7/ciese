require 'spec_helper'

describe UsersController do

  describe "PUT #update" do
    it_behaves_like "an action that requires an admin user", :put, :update, id: 1
  end

  describe "PUT #activate" do
    it_behaves_like "an action that requires an admin user", :put, :activate, id: 1
  end

  describe "PUT #deactivate" do
    it_behaves_like "an action that requires an admin user", :put, :deactivate, id: 1
  end
end
