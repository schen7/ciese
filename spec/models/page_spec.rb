require 'spec_helper'

describe Page do
  let(:page) { build(:page) }

  subject { page }

  it { should respond_to(:url) }
  it { should respond_to(:content) }
  it { should respond_to(:user) }
  it { should respond_to(:latest) }
  it { should respond_to(:published) }

  it { should be_valid }

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
  end

  describe "#user" do
    before { page.user = nil }

    it { should_not be_valid }
  end

  describe "#latest" do
    it "should have a default of false" do
      expect(page.latest).to be_false
    end
  end

  describe "#published" do
    it "should have a default of false" do
      expect(page.published).to be_false
    end
  end
end
