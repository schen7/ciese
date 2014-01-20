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
    context "when nil" do
      before { form_response.form_field = nil }

      it { should_not be_valid }
    end
  end

  describe "#form_version" do
    context "when nil" do
      before { form_response.form_version = nil }

      context "when #form_field is nil" do
        before { form_response.form_field = nil }

        it { should_not be_valid }
      end

      context "when #form_field is not nil" do
        it "should be valid after validation is run" do
          expect(form_response).to be_valid
          expect(form_response.form_version).to eq form_response.form_field.form_version 
        end
      end
    end
  end

  describe "#form_id" do
    context "when nil" do
      before { form_response.form_id = nil }

      context "when #form_field is nil" do
        before { form_response.form_field = nil }

        it { should_not be_valid }
      end

      context "when #form_field is not nil" do
        it "should be valid after validation is run" do
          expect(form_response).to be_valid
          expect(form_response.form_id).to eq form_response.form_field.form_version.form_id
        end
      end
    end
  end

  describe "#details" do
    context "when set to a hash and validated" do
      it "should be a Hash" do
        hash = { required: true, question: "What is the answer?" }
        form_response.details = hash
        form_response.save
        expect(form_response.details).to eq hash
      end
    end

    context "when set to nil and validated" do
      it "should be an empty hash" do
        form_response.details = nil
        form_response.valid?
        expect(form_response.details).to eq({})
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

