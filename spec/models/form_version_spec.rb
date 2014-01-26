require 'spec_helper'

describe FormVersion do
  let(:form_version) { build(:form_version) }

  subject { form_version }

  it { should respond_to(:form_id) }
  it { should respond_to(:project) }
  it { should respond_to(:slug) }
  it { should respond_to(:name) }
  it { should respond_to(:done_message) }
  it { should respond_to(:user) }
  it { should respond_to(:date) }
  it { should respond_to(:current_form) }
  it { should respond_to(:published_form) }
  it { should respond_to(:fields) }
  it { should respond_to(:responses) }

  it { should be_valid }

  describe "#form_id" do
    context "when empty and form is saved" do
      before { form_version.save }

      it "should equal the form's id" do
        expect(form_version.form_id).to eq form_version.id
      end
    end

    context "when set and form is saved" do
      before { form_version.form_id = 1000 }

      it "should not be changed" do
        form_version.save
        expect(form_version.form_id).to eq 1000
      end
    end
  end

  describe "#project" do
    context "when nil" do
      before { form_version.project = nil }

      it { should_not be_valid }
    end

    context "when not in Ciese::PROJECTS" do
      before { form_version.project = "no_good" }

      it { should_not be_valid }
    end
  end

  describe "#name" do
    context "when nil" do
      before { form_version.name = nil }

      it { should_not be_valid }
    end
    
    context "when saved" do
      it "should have a slug that is the parameterized name" do
        form_version.slug = nil
        form_version.save
        expect(form_version.slug).to eq form_version.name.parameterize
      end
    end
  end

  describe "#done_message" do
    context "when nil" do
      before { form_version.done_message = nil }
      
      it { should_not be_valid }
    end
  end

  describe "#user" do
    before { form_version.user = nil }

    it { should_not be_valid }
  end

  describe "#published?" do
    context "when form_version is not published" do
      its(:published?) { should be_false }
    end

    context "when form_version is published" do
      before do
        form_version.save
        create(:published_form, form_version: form_version)
      end

      its(:published?) { should be_true }
    end
  end

  describe "#fields" do
    before do
      form_version.save
      form_version.fields.create(kind: 'info')
    end

    context "when the form version is destroyed" do
      before { form_version.destroy }

      it "should cause all fields to be destroyed" do
        expect(FormField.all.count).to eq 0
      end
    end
  end

  describe "#date" do
    context "when updated_at is nil" do
      specify { expect(form_version.date).to be_nil }
    end
  end
end

