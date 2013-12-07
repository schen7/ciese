require 'spec_helper'

describe "PagePages" do

  subject { page }

  describe "list pages page" do
    let(:path) { admin_pages_path }

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
        let!(:pg) { create(:page, user: user, latest: true) }
        before { log_in_and_visit(user, path) }

        it "should list the pages" do
          expect(page).to have_content("Pages")
          expect(page).to have_link(pg.url, href: pg.url)
          expect(page).to have_content(pg.user.username)
          expect(page).not_to have_selector("i.fi-check")
          expect(page).to have_link("Create New Page", href: admin_new_page_path)
        end
      end

      context "when there is at least one published page" do
        let!(:pg) { create(:page, user: user, latest: true, published: true) }
        before { log_in_and_visit(user, path) }

        it "should list the pages and have the published? field checked" do
          expect(page).to have_content("Pages")
          expect(page).to have_link(pg.url, href: pg.url)
          expect(page).to have_content(pg.user.username)
          expect(page).to have_selector("i.fi-check")
          expect(page).to have_link("Create New Page", href: admin_new_page_path)
        end
      end

      context "when there are multiple versions of the same page" do
        let!(:pg1) { create(:page) }
        let!(:pg2) { create(:page, url: pg1.url) }
        let!(:pg3) { create(:page, url: pg1.url, latest: true) }
        before { log_in_and_visit(user, path) }

        it "should only show the latest version" do
          expect(page).not_to have_content(pg1.user.username)
          expect(page).not_to have_content(pg2.user.username)
          expect(page).to have_content(pg3.user.username)
        end
      end
    end
  end

  describe "new page page" do
    let(:path) { admin_new_page_path }

    it_behaves_like "a page that requires an active staff or admin user"

    context "when visited by an authorized user" do
      let(:user) { create(:staff) }
      before { log_in_and_visit(user, path) }

      it "renders the page editor" do
        expect(page).to have_content("Page Editor")
        expect(page).to have_selector("div#page-content")
        expect(page).to have_content("Save")
        expect(page).to have_content("Publish")
        expect(page).to have_link("Done", href: admin_pages_path)
      end

      context "when the save button is clicked" do
        before do
        
        end
      end
      
      context "when the publish button is clicked" do
      end
    end
  end

  describe "edit page page" do
  end

  describe "view page versions list page" do
  end

  describe "view page version page" do
  end

end
