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

  def versions
    @forms = FormVersion.includes(:published_form)
      .where(params.permit(:form_id)).order(id: :desc)
    render layout: "admin"
  end

  def show_version
    @form = FormVersion.includes(:user, :published_form).find(params[:id])
    @form_versions = FormVersion.where(form_id: @form.form_id).order(:id).ids
    render layout: "admin"
  end

  def new
    @form = FormVersion.new(name: "New Form")
    render "editor", layout: "admin"
  end

  def edit
    if !params[:vid].nil?
      @form = FormVersion.find(params[:vid])
    else
      current_form = CurrentForm.includes(:form_version).find_by(params.permit(:form_id))
      @form = current_form.form_version
    end
    render "editor", layout: "admin"
  end

end

