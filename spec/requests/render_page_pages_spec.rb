require 'spec_helper'

describe "RenderPage" do
  
  subject { page }

  describe "view page" do
    let(:pg) { create(:page, url: "/test", title: "testing", content: "hi there") }

    context "when not published" do
      it "should not render the page" do
        visit "/test"
        expect(page).not_to have_content("hi there")
        expect(page).to have_content("Not Found")
      end
    end

    context "when published" do
      let!(:published_page) { create(:published_page, version: pg) }

      it "should render the page" do
        visit "/test"
        expect(page).to have_title(full_title("testing"))
        expect(page).to have_content("hi there")
      end
    end
  end
end

