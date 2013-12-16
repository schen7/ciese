require 'spec_helper'

describe Page do
  let(:page) { build(:page) }

  subject { page }

  it { should respond_to(:page_id) }
  it { should respond_to(:url) }
  it { should respond_to(:content) }
  it { should respond_to(:user) }
  it { should respond_to(:current_page) }
  it { should respond_to(:published_page) }

  it { should be_valid }

  describe "#page_id" do
    context "when empty and page is saved" do
      before { page.save }

      it "should equal the page's id" do
        expect(page.page_id).to eq page.id
      end
    end

    context "when set and page is saved" do
      before { page.page_id = 1000 }

      it "should not be changed" do
        page.save
        expect(page.page_id).to eq 1000
      end
    end
  end


  describe "#url" do
    context "when blank" do
      before { page.url = "" }

      it { should_not be_valid }
    end

    context "when not properly formatted" do
      it "should not be valid" do
        ["//", "/no spaces", "needs/leading/slash", "/no//doubleslashes", "bad#char"].each do |url|
          page.url = url
          expect(page).not_to be_valid
        end
      end
    end

    context "when properly formatted" do
      it "should be valid" do
        ["/", "/no_spaces", "/needs/leading/slash", "/end/slash/"].each do |url|
          page.url = url
          expect(page).to be_valid
        end
      end
    end

    context "when ending with a slash" do
      before { page.url = "/page/" }

      it "removes the trailing slash" do
        page.save
        expect(page.url).to eq "/page"
      end
    end

    context "when only a single slash" do
      before { page.url = "/" }

      it "remains unaffected" do
        page.save
        expect(page.url).to eq "/"
      end
    end
  end

  describe "#user" do
    before { page.user = nil }

    it { should_not be_valid }
  end
end
