require 'spec_helper'

describe "MediaBrowserPages" do

  subject { page }

  describe "index page" do
    let(:path) { admin_mediabrowser_path }

    it_behaves_like "a page that requires an active staff or admin user"

    context "when visited by an authorized user" do
      before(:all) do
        @media_root = Api::MediabrowserController::MEDIA_ROOT
        @bad_path = @media_root.join('nog00d')
        @test_dir = @media_root.join('XXX_test_dir_101')
        @test_file = @media_root.join(@test_dir, 'XXX_test_file_101.txt')
        Dir.mkdir(@test_dir) if !Dir.exists?(@test_dir)
        File.new(@test_file, 'w+').close
      end
      after(:all) do
        File.unlink(@test_file)
        Dir.rmdir(@test_dir)
      end
      
      let(:user) { create(:staff) }
      let(:test_dir_name) { File.basename(@test_dir) }
      let(:test_file_name) { File.basename(@test_file) }
      before { log_in_and_visit(user, path) }

      it "should render the angular app and list files in media root path", js: true do
        expect(page).to have_content("Media Browser")
        expect(page).to have_content(test_dir_name)
      end

      context "when a folder link is clicked", js: true do
        before { click_link test_dir_name }

        it "should show the contents of that folder" do
          expect(page).to have_content(test_file_name)
        end
      end
    end
  end
end
