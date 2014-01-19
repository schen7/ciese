class Api::FormsController < ApplicationController
  
  before_action :api_require_login
  before_action :api_require_staff_or_admin

  def create
    form = FormVersion.new(form_params.merge(user: current_user))
    fields = (field_params[:fields] || []).map { |f| form.fields.build(f) }
    errors = []
    if form.valid? && fields.count { |f| !f.valid? } == 0
      begin
        FormVersion.transaction do
          form.save!
          fields.each { |f| f.save! }
          CurrentForm.where(form_id: form.form_id).destroy_all
          form.create_current_form!(form_id: form.form_id)
        end
      rescue Exception => e
        errors = [e.message]
      end
    else
      errors = form.errors.full_messages.uniq + 
               fields.map { |f| f.errors.full_messages }.flatten.uniq
    end
    if errors.any?
      render json: {errors: errors}
    else
      render json: {form_version_id: form.id, form_id: form.form_id}
    end
  end

  def show
    form = FormVersion.includes(:user, :published_form).find(params[:id])
    form_versions = FormVersion.where(form_id: form.form_id).order(:id).ids
    render json: form, meta: {form_versions: form_versions}
  end

  def update
    form = FormVersion.find(params.permit(:id)[:id])
    published_form = PublishedForm.find_by(form_id: form.form_id)
    if published_form.nil?
      published_form = PublishedForm.new(form_version_id: form.id, form_id: form.form_id)
    else
      published_form.form_version_id = form.id
    end
    if published_form.save
      render json: {published: true}
    else
      render json: {published: false, errors: published_form.errors.full_messages}
    end
  end

  def destroy
    form_version = FormVersion.find(params[:id])
    PublishedForm.where(form_id: form_version.form_id).destroy_all
    render json: {unpublished: true}
  end

  private

  def form_params
    params.require(:form).permit(:form_id, :project, :name)
  end

  def field_params
    params.require(:form).permit(fields: [:kind, :details])
  end

  def publish_params
    params.permit(:form_version_id, :form_id)
  end

end


