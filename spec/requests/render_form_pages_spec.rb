require 'spec_helper'

describe "RenderForm" do
  
  subject { page }

  describe "render form page" do
    let(:form_version) { create(:form_version, name: "Test Form") }
    let!(:form_field) do
      create(:form_field, form_version: form_version, kind: 'short-answer',
             details: {question: "Answer this question.", label: "Answer"})
    end

    context "when not published" do
      before { visit fill_out_form_path(form_version.project, form_version.slug) }

      it "should not render the form" do
        expect(page).not_to have_content(form_version.name)
        expect(page).not_to have_content(form_field.details[:question])
        expect(page).not_to have_content(form_field.details[:label])
        expect(page).to have_content("Not Found")
      end
    end

    context "when published" do
      let!(:published_form) { create(:published_form, form_version: form_version) }
      before { visit fill_out_form_path(form_version.project, form_version.slug) }

      it "should render the form" do
        expect(page).to have_title(full_title(form_version.name))
        expect(page).to have_content(form_version.name)
        expect(page).to have_content(form_field.details[:question])
        expect(page).to have_content(form_field.details[:label])
      end

      context "when the form is filled out and submitted" do
        before do
          fill_in "responses[#{form_field.id}][response]", with: "the answer"
          click_on("Submit")
        end

        it "should save the response" do
          expect(page.current_url).not_to eq fill_out_form_path(form_version.project, form_version.slug)
          expect(page.current_path).to eq root_path
          expect(FormResponse.last.details[:response]).to eq "the answer"
        end
      end

      context "when non-required fields are left blank" do
        before { click_on("Submit") }

        it "should save the response" do
          expect(page.current_url).not_to eq fill_out_form_path(form_version.project, form_version.slug)
          expect(FormResponse.last.details[:response]).to be_blank
        end
      end

      context "when required fields are left blank" do
        before do
          form_field.details[:required] = true
          form_field.save
          click_on("Submit")
        end

        it "should not save the response" do
          expect(page).to have_content("Response required")
        end
      end
    end
  end
end

