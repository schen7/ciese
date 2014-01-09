require 'spec_helper'

describe FormResponse do
  let(:form_response) { build(:form_response) }

  subject { form_response }

  it { should respond_to(:form_field) }
  it { should respond_to(:form_version) }
  it { should respond_to(:form_id) }
  it { should respond_to(:user) }
  it { should respond_to(:details) }

  it { should be_valid }

  describe "#form_field" do
    context "when blank" do
      before { form_response.form_field = nil }

      it { should_not be_valid }
    end

    context "when set" do
      before { form_response.form_field = create(:form_field) }

      it "should also set the form_version and form_id fields" do
        expect(form_response.form_version).to eq form_response.form_field.form_version
        expect(form_response.form_id).to eq form_response.form_version.form_id
      end
    end
  end

  describe "#form_version" do
    context "when set manually" do
      it "should be ignored" do
        old_form_version = form_response.form_version
        form_response.form_version = create(:form_version)
        expect(form_response.form_version).to eq old_form_version
      end
    end
  end

  describe "#form_id" do
    context "when set manually" do
      it "should be ignored" do
        old_form_id = form_response.form_id
        form_response.form_id = old_form_id + 1
        expect(form_response.form_id).to eq old_form_id
      end
    end
  end

end

