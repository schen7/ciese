require 'spec_helper'

describe 'FormBuilderPages' do

  subject { page }

  describe "current forms list" do
    let(:path) { admin_forms_path }

    it_behaves_like "a page that requires an active staff or admin user"

    context "when visited by an authorized user" do
      let(:user) { create(:staff) }

      context "when there are no forms yet" do
        before { log_in_and_visit(user, path) }

        it "should display a message that there are no forms" do
          expect(page).to have_content("There are no forms yet.")
          expect(page).to have_link("Create New Form", href: admin_new_form_path)
        end
      end

      context "when there is at least one form" do
        let!(:current_form) { create(:current_form) }
        let(:form_version) { current_form.form_version }
        before { log_in_and_visit(user, path) }

        it "should list the forms" do
          expect(page).to have_content("Forms")
          expect(page).to have_link(
            form_version.name, href: admin_edit_form_path(current_form.form_id)
          )
          expect(page).to have_content(form_version.user.username)
          expect(page).to have_content(form_version.slug)
          expect(page).not_to have_selector("i.fi-check")
          expect(page).to have_link(
            form_version.date.gsub(/ +/, " "),
            href: admin_form_versions_path(current_form.form_id)
          )
          expect(page).to have_link("Create New Form", href: admin_new_form_path)
        end
      end

      context "when there is at least one current published form" do
        let!(:current_form) { create(:current_form) }
        let(:form_version) { current_form.form_version }
        let!(:published_form) { create(:published_form, form_version: form_version) }
        before { log_in_and_visit(user, path) }

        it "should list the forms and have the published? field checked" do
          expect(page).to have_content("Forms")
          expect(page).to have_link(
            form_version.name, href: admin_edit_form_path(current_form.form_id)
          )
          expect(page).to have_content(form_version.user.username)
          expect(page).to have_selector(
            "tbody tr > td:first + td + td + td + td > i.fi-check"
          )
          expect(page).not_to have_selector(
            "tbody tr > td:first + td + td + td + td + td> i.fi-check"
          )
          expect(page).to have_link("Create New Form", href: admin_new_form_path)
        end
      end

      context "when there is at least one previously published form" do
        let!(:current_form) { create(:current_form) }
        let(:form_version) { current_form.form_version }
        let!(:published_form) { create(:published_form, form_id: current_form.form_id) }
        before { log_in_and_visit(user, path) }

        it "should list the forms and have the published? field checked" do
          expect(page).to have_content("Forms")
          expect(page).to have_link(
            form_version.name, href: admin_edit_form_path(current_form.form_id)
          )
          expect(page).to have_content(form_version.user.username)
          expect(page).not_to have_selector(
            "tbody tr > td:first + td + td + td + td > i.fi-check"
          )
          expect(page).to have_selector(
            "tbody tr > td:first + td + td + td + td + td> i.fi-check"
          )
          expect(page).to have_link("Create New Form", href: admin_new_form_path)
        end
      end
    end
  end

  describe "new form" do
    let(:path) { admin_new_form_path }

    it_behaves_like "a page that requires an active staff or admin user"

    context "when visited by an authorized user" do
      let(:user) { create(:staff) }
      before { log_in_and_visit(user, path) }

      it "renders the form editor" do
        expect(page).to have_content("Form Editor")
        expect(page).to have_content("Save")
        expect(page).to have_content("Publish")
        expect(page).to have_link("Done", href: admin_forms_path)
      end

      context "when the save button is clicked", js: true do
        before do
          first(".form-field").click
          fill_in "name", with: "A Test Form"
          find_button("save-button").click
        end

        it "should save the form" do
          expect(page).to have_content("Form Editor")
          expect(page).to have_css("#save-button[disabled]")
          expect(page.current_path).to eq admin_edit_form_path(FormVersion.last.form_id)
          visit admin_forms_path
          expect(page).to have_link("A Test Form")
        end

        context "when the published button is clicked", js: true do
          before { find_button("publish-button").click }

          it "should publish the form" do
            expect(page).to have_content("Form Editor")
            expect(page).to have_css("#publish-button[disabled]")
            visit admin_forms_path
            expect(page).to have_selector("i.fi-check")
          end
        end
      end
    end
  end

  describe "edit form" do
    let(:current_form) { create(:current_form) }
    let(:path) { admin_edit_form_path(current_form.form_id) }

    it_behaves_like "a page that requires an active staff or admin user"

    context "when visited by an authorized user", :js do
      let(:user) { create(:staff) }

      it "renders the form editor" do
        log_in_and_visit(user, path)
        expect(page).to have_content("Form Editor")
        expect(page).to have_content("Save")
        expect(page).to have_content("Publish")
        expect(page).to have_link("Done", href: admin_forms_path)
        expect(page.find("input[name=name]", visible: false).value).to eq current_form.form_version.name
      end

      context "when a version id is specified in the query string" do
        let(:form_version) { create(:form_version, form_id: current_form.form_id) }
        before { log_in_and_visit(user, "#{path}?vid=#{form_version.id}") }

        it "renders the proper version" do
          expect(page.find("input[name=name]", visible: false).value).not_to eq current_form.form_version.name
          expect(page.find("input[name=name]", visible: false).value).to eq form_version.name
        end

        context "when the save button is clicked" do
          before do
            first(".form-field").click
            fill_in "name", with: "A New Name"
            find_button("save-button").click
          end

          it "should save the page" do
            expect(page).to have_content("Form Editor")
            expect(page).to have_css("#save-button[disabled]")
            expect(page.current_url).to end_with admin_edit_form_path(current_form.form_id)
            visit admin_forms_path
            expect(page).to have_content("A New Name")
          end

          context "when the published button is clicked" do
            before { find_button("publish-button").click }

            it "should publish the page" do
              expect(page).to have_content("Form Editor")
              expect(page).to have_css("#publish-button[disabled]")
              visit admin_forms_path
              expect(page).to have_selector("i.fi-check")
            end
          end
        end
      end
    end
  end

  describe "form versions list", :focus do
    let!(:form_version1) { create(:form_version) } 
    let!(:form_version2) { create(:form_version, form_id: form_version1.form_id, name: form_version1.name) } 
    let!(:current_form) { create(:current_form, form_version: form_version2) }
    let(:path) { admin_form_versions_path(form_version1.form_id) }

    it_behaves_like "a page that requires an active staff or admin user"

    context "when visited by an authorized user" do
      let(:user) { create(:staff) }

      it "should list the form versions" do
        log_in_and_visit(user, path)
        expect(page).to have_content("Form Versions")
        version_path1 = admin_form_version_path(form_version1.form_id, form_version1.id)
        version_path2 = admin_form_version_path(form_version2.form_id, form_version2.id)
        expect(page).to have_link(form_version1.name, href: version_path1)
        expect(page).to have_link(form_version2.name, href: version_path2)
        expect(page).to have_content(form_version1.user.username)
        expect(page).to have_content(form_version2.user.username)
        expect(page).to have_link("Done", href: admin_forms_path)
      end

      context "when the current version is published" do
        before { create(:published_form, form_version: form_version2) }

        it "should indicate the latest version is published" do
          log_in_and_visit(user, path)
          expect(page).to have_selector("tbody tr:first i.fi-check")
          expect(page).not_to have_selector("tbody tr:last i.fi-check")
        end
      end

      context "when a previous version is published" do
        before { create(:published_form, form_version: form_version1) }

        it "should indicate the latest version is published" do
          log_in_and_visit(user, path)
          expect(page).not_to have_selector("tbody tr:first i.fi-check")
          expect(page).to have_selector("tbody tr:last i.fi-check")
        end
      end
    end
  end
end
