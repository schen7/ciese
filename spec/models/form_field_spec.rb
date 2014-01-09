require 'spec_helper'

describe FormField do
  let(:form_field) { build(:form_field) }

  subject { form_field }

  it { should respond_to(:form_version) }
  it { should respond_to(:kind) }
  it { should respond_to(:required) }
  it { should respond_to(:details) }

  it { should be_valid }

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

  describe "#required" do
    context "when nil" do
      before { form_field.required = nil }

      it { should_not be_valid }
    end
  end

end

