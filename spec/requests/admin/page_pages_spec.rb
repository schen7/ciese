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
          expect(page).to have_link(
            version.url, href: admin_edit_page_path(current_page.page_id)
          )
          expect(page).to have_content(version.user.username)
          expect(page).not_to have_selector("i.fi-check")
          expect(page).to have_link(
            version.updated_at.to_formatted_s(:long),
            href: admin_page_versions_path(current_page.page_id)
          )
          expect(page).to have_link("Create New Page", href: admin_new_page_path)
        end
      end

      context "when there is at least one current published page" do
        let!(:current_page) { create(:current_page) }
        let!(:published_page) do
          create(:published_page, version: current_page.version)
        end
        let(:version) { current_page.version }
        before { log_in_and_visit(user, path) }

        it "should list the pages and have the published? field checked" do
          expect(page).to have_content("Pages")
          expect(page).to have_link(
            version.url, href: admin_edit_page_path(current_page.page_id)
          )
          expect(page).to have_content(version.user.username)
          expect(page).to have_selector(
            "tbody tr > td:first + td + td + td > i.fi-check"
          )
          expect(page).not_to have_selector(
            "tbody tr > td:first + td + td + td + td> i.fi-check"
          )
          expect(page).to have_link("Create New Page", href: admin_new_page_path)
        end
      end

      context "when there is at least one previously published page" do
        let!(:current_page) { create(:current_page) }
        let!(:published_page) do
          create(:published_page, page_id: current_page.page_id)
        end
        let(:version) { current_page.version }
        before { log_in_and_visit(user, path) }

        it "should list the pages and have the published? field checked" do
          expect(page).to have_content("Pages")
          expect(page).to have_link(
            version.url, href: admin_edit_page_path(current_page.page_id)
          )
          expect(page).to have_content(version.user.username)
          expect(page).not_to have_selector(
            "tbody tr > td:first + td + td + td > i.fi-check"
          )
          expect(page).to have_selector(
            "tbody tr > td:first + td + td + td + td> i.fi-check"
          )
          expect(page).to have_link("Create New Page", href: admin_new_page_path)
        end
      end
    end
  end

  describe "new page" do
    let(:path) { admin_new_page_path }

    it_behaves_like "a page that requires an active staff or admin user"

    context "when visited by an authorized user" do
      let(:user) { create(:staff) }
      before { log_in_and_visit(user, path) }

      it "renders the page editor" do
        expect(page).to have_content("Page Editor")
        expect(page).to have_selector("div#content-editor")
        expect(page).to have_content("Save")
        expect(page).to have_content("Publish")
        expect(page).to have_link("Done", href: admin_current_pages_path)
      end

      context "when the save button is clicked", js: true do
        before do
          fill_in "url", with: "/test/url"
          find_button("save-button").click
        end

        it "should save the page" do
          expect(page).to have_content("Page Editor")
          expect(page).to have_css("#save-button[disabled]")
          expect(page.current_path).to eq admin_edit_page_path(Page.last.page_id)
          visit admin_current_pages_path
          expect(page).to have_link("/test/url")
        end

        context "when the published button is clicked", js: true do
          before { find_button("publish-button").click }

          it "should publish the page" do
            expect(page).to have_content("Page Editor")
            expect(page).to have_css("#publish-button[disabled]")
            visit admin_current_pages_path
            expect(page).to have_selector("i.fi-check")
          end
        end
      end
    end
  end

  describe "edit page" do
    let(:current_page) { create(:current_page) }
    let(:path) { admin_edit_page_path(current_page.page_id) }

    it_behaves_like "a page that requires an active staff or admin user"

    context "when visited by an authorized user" do
      let(:user) { create(:staff) }
      before { log_in_and_visit(user, path) }

      it "renders the page editor" do
        expect(page).to have_content("Page Editor")
        expect(page).to have_selector("div#content-editor")
        expect(page).to have_content("Save")
        expect(page).to have_content("Publish")
        expect(page).to have_link("Done", href: admin_current_pages_path)
      end

      context "when the save button is clicked", js: true do
        before do
          fill_in "url", with: "/test/url"
          find_button("save-button").click
        end

        it "should save the page" do
          expect(page).to have_content("Page Editor")
          expect(page).to have_css("#save-button[disabled]")
          expect(page.current_path).to eq admin_edit_page_path(current_page.page_id)
          visit admin_current_pages_path
          expect(page).to have_link("/test/url")
        end

        context "when the published button is clicked", js: true do
          before { find_button("publish-button").click }

          it "should publish the page" do
            expect(page).to have_content("Page Editor")
            expect(page).to have_css("#publish-button[disabled]")
            visit admin_current_pages_path
            expect(page).to have_selector("i.fi-check")
          end
        end
      end
    end
  end

  describe "page versions list" do
    let!(:page1) { create(:page) } 
    let!(:page2) { create(:page, page_id: page1.page_id, url: page1.url) } 
    let!(:current_page) { create(:current_page, version: page2) }
    let(:path) { admin_page_versions_path(page1.page_id) }

    it_behaves_like "a page that requires an active staff or admin user"

    context "when visited by an authorized user" do
      let(:user) { create(:staff) }

      it "should list the page versions" do
        log_in_and_visit(user, path)
        expect(page).to have_content("Page Versions")
        version_path1 = admin_page_version_path(page1.page_id, page1.id)
        version_path2 = admin_page_version_path(page2.page_id, page2.id)
        expect(page).to have_link(page1.url, href: version_path1)
        expect(page).to have_link(page2.url, href: version_path2)
        expect(page).to have_content(page1.user.username)
        expect(page).to have_content(page2.user.username)
        expect(page).to have_link("Done", href: admin_pages_path)
      end

      context "when the current version is published" do
        before { create(:published_page, version: page2) }

        it "should indicate the latest version is published" do
          log_in_and_visit(user, path)
          expect(page).to have_selector("tbody tr:first i.fi-check")
          expect(page).not_to have_selector("tbody tr:last i.fi-check")
        end
      end

      context "when a previous version is published" do
        before { create(:published_page, version: page1) }

        it "should indicate the latest version is published" do
          log_in_and_visit(user, path)
          expect(page).not_to have_selector("tbody tr:first i.fi-check")
          expect(page).to have_selector("tbody tr:last i.fi-check")
        end
      end
    end
  end

  describe "page version" do
    let!(:page1) { create(:page) }
    let!(:page2) { create(:page, url: page1.url, page_id: page1.page_id) }
    let!(:page3) { create(:page, url: page1.url, page_id: page1.page_id) }
    let(:current_page) { create(:current_page, version: page3) }
    let(:path) { admin_page_version_path(page3.page_id, page3.id) }
    let(:versions_path) { admin_page_versions_path(page3.page_id) }

    it_behaves_like "a page that requires an active staff or admin user"

    context "when visited by an authorized user" do
      let(:user) { create(:staff) }

      it "shows the page version" do
        log_in_and_visit(user, path)
        expect(page).to have_content("Page Version")
        edit_link = ("#{admin_edit_page_path(current_page.page_id)}" + 
                     "?vid=#{current_page.version_id}")
        expect(page).to have_link("Edit", href: edit_link)
        expect(page).to have_link("Done", href: versions_path)
      end

      context "when the current version is not published" do
        it "should indicate that this version is not published" do
          log_in_and_visit(user, path)
          expect(page).not_to have_selector("h2.published")
          expect(page).to have_selector("#publish-button")
        end
      end

      context "when the current version is published" do
        before { create(:published_page, version: page3) }

        it "should indicate that this version is published" do
          log_in_and_visit(user, path)
          expect(page).to have_selector("h2.published")
          expect(page).to have_selector("#unpublish-button")
        end
      end

      context "when there is a previous version", :js do
        it "should have the previous version button enabled" do
          log_in_and_visit(user, admin_page_version_path(page3.page_id, page3.id))
          expect(page).not_to have_selector("#prev-button[disabled]")
        end
      end

      context "when there is not a previous version", :js do
        it "should have the previous version button disabled" do
          log_in_and_visit(user, admin_page_version_path(page1.page_id, page1.id))
          expect(page).to have_selector("#prev-button[disabled]")
        end
      end

      context "when the previous version button is clicked", :js do
        it "should show the previous version" do
          log_in_and_visit(user, admin_page_version_path(page3.page_id, page3.id))
          find("#prev-button").click
          expect(page).to have_content(page2.url)
          expect(page.current_path).to end_with(page2.id.to_s)
        end
      end

      context "when there is a next version", :js do
        it "should have the next version button enabled" do
          log_in_and_visit(user, admin_page_version_path(page1.page_id, page1.id))
          expect(page).not_to have_selector("#next-button[disabled]")
        end
      end

      context "when there is not a next version", :js do
        it "should have the next version button disabled" do
          log_in_and_visit(user, admin_page_version_path(page3.page_id, page3.id))
          expect(page).to have_selector("#next-button[disabled]")
        end
      end

      context "when the next version button is clicked", :js do
        it "should show the next version" do
          log_in_and_visit(user, admin_page_version_path(page1.page_id, page1.id))
          find("#next-button").click
          expect(page).to have_content(page2.url)
          expect(page.current_path).to end_with(page2.id.to_s)
        end
      end
    end
  end
end
