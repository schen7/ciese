require 'spec_helper'

describe "PageEditorPages" do

  subject { page }

  describe "current pages list" do
    let(:path) { admin_current_pages_path }

    it_behaves_like "a page that requires an active staff or admin user"

    context "when visited by an authorized user" do
      let(:user) { create(:staff) }

      context "when there are no pages yet" do
        before { log_in_and_visit(user, path) }

        it "should display a message that there are no pages" do
          expect(page).to have_content("There are no pages yet.")
          expect(page).to have_link("Create New Page", href: admin_new_page_path)
        end
      end

      context "when there is at least one page" do
        let!(:current_page) { create(:current_page) }
        let(:version) { current_page.version }
        before { log_in_and_visit(user, path) }

        it "should list the pages" do
          expect(page).to have_content("Pages")
          expect(page).to have_link(version.url, href: admin_page_versions_path(current_page.page_id))
          expect(page).to have_content(version.user.username)
          expect(page).not_to have_selector("i.fi-check")
          expect(page).to have_link("Create New Page", href: admin_new_page_path)
        end
      end

      context "when there is at least one current published page" do
        let!(:current_page) { create(:current_page) }
        let!(:published_page) { create(:published_page, version: current_page.version) }
        let(:version) { current_page.version }
        before { log_in_and_visit(user, path) }

        it "should list the pages and have the published? field checked" do
          expect(page).to have_content("Pages")
          expect(page).to have_link(version.url, href: admin_page_versions_path(current_page.page_id))
          expect(page).to have_content(version.user.username)
          expect(page).to have_selector("tbody tr > td:first + td + td + td > i.fi-check")
          expect(page).not_to have_selector("tbody tr td:last i.fi-check")
          expect(page).to have_link("Create New Page", href: admin_new_page_path)
        end
      end

      context "when there is at least one previously published page" do
        let!(:current_page) { create(:current_page) }
        let!(:published_page) { create(:published_page, page_id: current_page.page_id) }
        let(:version) { current_page.version }
        before { log_in_and_visit(user, path) }

        it "should list the pages and have the published? field checked" do
          expect(page).to have_content("Pages")
          expect(page).to have_link(version.url, href: admin_page_versions_path(current_page.page_id))
          expect(page).to have_content(version.user.username)
          expect(page).not_to have_selector("tbody tr > td:first + td + td + td > i.fi-check")
          expect(page).to have_selector("tbody tr td:last i.fi-check")
          expect(page).to have_link("Create New Page", href: admin_new_page_path)
        end
      end
    end
  end

  # describe "page editor" do
  #   let(:path) { admin_new_page_path }

  #   it_behaves_like "a page that requires an active staff or admin user"

  #   context "when visited by an authorized user" do
  #     let(:user) { create(:staff) }
  #     before { log_in_and_visit(user, path) }

  #     it "renders the page editor" do
  #       expect(page).to have_content("Page Editor")
  #       expect(page).to have_selector("div#content-editor")
  #       expect(page).to have_content("Save")
  #       expect(page).to have_content("Publish")
  #       expect(page).to have_link("Done", href: admin_current_pages_path)
  #     end

  #     context "when the save button is clicked", js: true do
  #       before do
  #         fill_in "url", with: "/test/url"
  #         find("#save-button").click
  #       end

  #       it "should save the page" do
  #         expect(page).to have_content("Page Editor")
  #         expect(page).to have_css("#save-button[disabled]")
  #         visit admin_current_pages_path
  #         expect(page).to have_link("/test/url")
  #       end
  #     end
      
  #     context "when the publish button is clicked" do
  #     end
  #   end
  # end

  # describe "page versions list" do
  #   let!(:page1) { create(:page) } 
  #   let!(:page2) { create(:page, page_id: page1.page_id, url: page1.url) } 
  #   let(:path) { admin_page_versions_path }

  #   it_behaves_like "a page that requires an active staff or admin user"

  #   context "when visited by an authorized user" do
  #     let(:user) { create(:staff) }
  #     before { log_in_and_visit(user, admin_page_versions_path(page1.page_id)) }

  #     it "should list the page versions" do
  #       expect(page).to have_content("Page Versions")
  #       expect(page).to have_link(page1.url, href: admin_page_edit_path(page1.id))
  #       expect(page).to have_content(current_page.user.username)
  #       expect(page).not_to have_selector("i.fi-check")
  #       expect(page).to have_link("Create New Page", href: admin_new_page_path)
  #     end
  #   end
  # end

  # describe "view page version page" do
  # end

end
