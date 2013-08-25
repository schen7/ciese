require 'spec_helper'

describe "ProfilePages" do

  subject { page }

  describe "index page" do
    before { visit profiles_path }

    it "should render the angular app" do
      expect(page).to have_content('CIESE Participant Profiles')
    end
  end

  describe "new profile page" do
  end

  describe "show profile page" do
  end
end
