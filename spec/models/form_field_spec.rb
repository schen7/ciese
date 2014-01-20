require 'spec_helper'

describe FormField do
  let(:form_field) { build(:form_field) }

  subject { form_field }

  it { should respond_to(:form_version) }
  it { should respond_to(:kind) }
  it { should respond_to(:details) }
  it { should respond_to(:responses) }

  it { should be_valid }

  describe "#form_version" do
    context "when nil" do
      before { form_field.form_version = nil }

      it { should_not be_valid }
    end
  end

  describe "#kind" do
    context "when blank" do
      before { form_field.kind = nil }

      it { should_not be_valid }
    end

    context "when not in KINDS" do
      before { form_field.kind = "invalid" }

      it { should_not be_valid }
    end
  end

  describe "#details" do
    it "should be a Hash" do
      hash = { required: true, question: "What is the answer?" }
      form_field.details = hash
      form_field.save
      expect(form_field.details).to eq hash
    end
  end

end

