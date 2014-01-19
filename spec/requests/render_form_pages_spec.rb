require 'spec_helper'

# describe "RenderForm" do
  
#   subject { page }

#   describe "render form page" do
#     let(:form_version) { create(:form_version, name: "Test Form") }
#     before do
#       create(:form_field, form_version: form_version, kind: 'short-answer-field')
#     end

#     context "when not published" do
#       it "should not render the form" do
#         visit "/forms/#{form_version.slug}"
#         expect(page).not_to have_content(form_version.name)
#         expect(page).to have_content("Not Found")
#       end
#     end

#     context "when published" do
#       let!(:published_form) { create(:published_form, version: pg) }

#       it "should render the form" do
#         visit "/forms/#{form_version.slug}"
#         expect(page).to have_title(full_title(form_version.name))
#         expect(page).to have_content(form_version.name)
#       end
#     end
#   end
# end

