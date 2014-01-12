class Admin::FormsController < ApplicationController

  before_action :require_login
  before_action :require_staff_or_admin

  def index
    @forms = FormVersion
      .joins("LEFT OUTER JOIN published_forms ON published_forms.form_id = form_versions.form_id")
      .select(
        "form_versions.*, " +
        "(published_forms.form_version_id IS NOT NULL AND published_forms.form_version_id = form_versions.id) as published, " +
        "(published_forms.form_version_id IS NOT NULL AND published_forms.form_version_id != form_versions.id) as prev_published"
      )
      .joins(:current_form)
      .includes(:user)
      .order(name: :asc)
    render layout: "admin"
  end

  def new
    @form = FormVersion.new(name: "New Form")
    render "editor", layout: "admin"
  end

end

