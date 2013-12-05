require 'spec_helper'

describe Page do
  let(:page) { build(:page) }

  it { should respond_to(:url) }
  it { should respond_to(:content) }
  it { should respond_to(:user) }
  it { should respond_to(:published_page) }
  it { should respond_to(:published?) }

  it { should be_valid }

  describe "#published?" do
    context "when page is not published" do

      it "should be false" do
        expect(page.published?).to be_false
      end
    end

    context "when page is published" do
      before do
        page.save
        page.create_published_page(url: page.url, user: page.user)
      end

      it "should be true" do
        expect(page.published?).to be_true
      end
    end
  end

end
