require 'spec_helper'

describe PublishedPage do
  let(:published_page) { build(:published_page) }

  it { should respond_to(:url) }
  it { should respond_to(:page) }
  it { should respond_to(:user) }

  it { should be_valid }

  describe "#url" do
    it "should be unique" do
      published_page.save
      other_page = build(:page, url: published_page.page.url)
      other_published_page = build(:published_page, page: other_page)
      expect(other_published_page).not_to be_valid
    end
  end

end
