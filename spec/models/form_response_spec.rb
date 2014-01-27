require 'spec_helper'

describe FormResponse do
  let(:form_response) { build(:form_response) }

  subject { form_response }

  it { should respond_to(:form_version) }
  it { should respond_to(:form_id) }
  it { should respond_to(:user) }
  it { should respond_to(:date) }
  it { should respond_to(:field_responses) }

  it { should be_valid }

  describe "#form_version" do
    context "when nil" do
      before { form_response.form_version = nil }

      it { should_not be_valid }
    end
  end

  describe "#form_id" do
    context "when nil" do
      before { form_response.form_id = nil }

      context "when #form_version is nil" do
        before { form_response.form_version = nil }

        it { should_not be_valid }
      end

      context "when #form_version is not nil" do
        it "should be valid after validation is run" do
          expect(form_response).to be_valid
          expect(form_response.form_id).to eq form_response.form_version.form_id
        end
      end
    end
  end

end


