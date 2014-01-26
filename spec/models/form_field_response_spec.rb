require 'spec_helper'

describe FormFieldResponse do
  let(:form_field_response) { build(:form_field_response) }

  subject { form_field_response }

  it { should respond_to(:form_field) }
  it { should respond_to(:details) }
  it { should respond_to(:form_response) }

  it { should be_valid }

  describe "#form_field" do
    context "when nil" do
      before { form_field_response.form_field = nil }

      it { should_not be_valid }
    end
  end

  describe "#details" do
    context "when set to a hash and validated" do
      it "should be a Hash" do
        hash = { required: true, question: "What is the answer?" }
        form_field_response.details = hash
        form_field_response.save
        expect(form_field_response.details).to eq hash
      end
    end

    context "when set to nil and validated" do
      it "should be an empty hash" do
        form_field_response.details = nil
        form_field_response.valid?
        expect(form_field_response.details).to eq({})
      end
    end
  end

  describe "field validations" do

    describe "info field" do
      let(:form_field) { build(:form_field, kind: "info") }
      let(:response) { form_field.responses.build }

      specify { expect(response).to be_valid }
    end

    describe "short-answer field" do
      let(:form_field) { build(:form_field, kind: "short-answer") }
      let(:response) { form_field.responses.build(details: {}) }

      context "when not required and left blank" do
        specify { expect(response).to be_valid }
      end

      context "when required and left blank" do
        before { form_field.details[:required] = true }

        specify { expect(response).not_to be_valid }
      end

      context "when required and filled in" do
        before do
          form_field.details[:required] = true
          response.details[:response] = "an answer"
        end

        specify { expect(response).to be_valid }
      end
    end

    describe "long-answer field" do
      let(:form_field) { build(:form_field, kind: "long-answer") }
      let(:response) { form_field.responses.build(details: {}) }

      context "when not required and left blank" do
        specify { expect(response).to be_valid }
      end

      context "when required and left blank" do
        before { form_field.details[:required] = true }

        specify { expect(response).not_to be_valid }
      end

      context "when required and filled in" do
        before do
          form_field.details[:required] = true
          response.details[:response] = "an answer"
        end

        specify { expect(response).to be_valid }
      end
    end

    describe "single-choice field" do
      let(:form_field) do
        details = {choices: [{"label"=>"A"}, {"label"=>"B"}, {"label"=>"C"}]}
        build(:form_field, kind: "single-choice", details: details)
      end
      let(:response) { form_field.responses.build(details: {}) }

      context "when not required and left blank" do
        specify { expect(response).to be_valid }
      end

      context "when required and left blank" do
        before { form_field.details[:required] = true }

        specify { expect(response).not_to be_valid }
      end

      context "when required and filled in" do
        before do
          form_field.details[:required] = true
          response.details[:response] = "B"
        end

        specify { expect(response).to be_valid }
      end

      context "when required and filled in with an invalid choice" do
        before do
          form_field.details[:required] = true
          response.details[:response] = "X"
        end

        specify { expect(response).not_to be_valid }
      end
    end

    describe "multiple-choice field" do
      let(:form_field) do
        details = {choices: [{"label"=>"A"}, {"label"=>"B"}, {"label"=>"C"}]}
        build(:form_field, kind: "multiple-choice", details: details)
      end
      let(:response) { form_field.responses.build(details: {}) }

      context "when not required and left blank" do
        specify { expect(response).to be_valid }
      end

      context "when required and left blank" do
        before { form_field.details[:required] = true }

        specify { expect(response).not_to be_valid }
      end

      context "when required and filled in" do
        before do
          form_field.details[:required] = true
          response.details[:responses] = {"B"=>"1"}
        end

        specify { expect(response).to be_valid }
      end

      context "when required and filled in with an invalid choice" do
        before do
          form_field.details[:required] = true
          response.details[:responses] = {"X"=>"1"}
        end

        specify { expect(response).not_to be_valid }
      end
    end
  end

end

