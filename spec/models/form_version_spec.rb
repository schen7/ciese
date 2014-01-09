require 'spec_helper'

describe FormVersion do
  let(:form_version) { build(:form_version) }

  subject { form_version }

  it { should respond_to(:form_id) }
  it { should respond_to(:slug) }
  it { should respond_to(:name) }
  it { should respond_to(:user) }
  it { should respond_to(:current_form) }
  it { should respond_to(:published_form) }
  it { should respond_to(:fields) }

  it { should be_valid }

  describe "#slug" do
    context "when nil" do
      before { form_version.slug = nil }

      it { should_not be_valid }
    end

    context "when blank" do
      before { form_version.slug = "" }

      it { should_not be_valid }
    end

    context "when contains non-parameterized characters" do
      let(:slug) { "An Inv@lid Slug!" }
      before { form_version.slug = slug }

      it "should be paramaterized" do
        expect(form_version.slug).to eq slug.parameterize
      end
    end
  end

  describe "#name" do
    before { form_version.name = nil }

    it { should_not be_valid }
  end

  describe "#user" do
    before { form_version.user = nil }

    it { should_not be_valid }
  end

end

