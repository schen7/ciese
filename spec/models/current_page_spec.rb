require 'spec_helper'

describe CurrentPage do
  let(:current_page) { build(:current_page) }

  subject { current_page }

  it { should respond_to(:version) }
  it { should respond_to(:page_id) }

  it { should be_valid }

  describe "with_publish_info scope" do
    before { current_page.save }

    context "when no page versions are published" do
      let(:c_page) { CurrentPage.with_publish_info.find(current_page.id) }

      specify { expect(c_page.published).to be_false }
      specify { expect(c_page.prev_published).to be_false }
    end

    context "when current page is published" do
      before { create(:published_page, version: current_page.version) }
      let(:c_page) { CurrentPage.with_publish_info.find(current_page.id) }

      specify { expect(c_page.published).to be_true }
      specify { expect(c_page.prev_published).to be_false }
    end

    context "when a previous page version is published" do
      before { create(:published_page, page_id: current_page.page_id) }
      let(:c_page) { CurrentPage.with_publish_info.find(current_page.id) }

      specify { expect(c_page.published).to be_false }
      specify { expect(c_page.prev_published).to be_true }
    end
  end
end
