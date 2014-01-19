class Api::FormsController < ApplicationController
  
  before_action :api_require_login
  before_action :api_require_staff_or_admin

  def create
    form_version = FormVersion.new(form_version_params.merge(user: current_user))
    fields = (field_params || []).map { |f| form_version.fields.build(f.slice(:kind, :details)) }
    errors = []
    if form_version.valid? && fields.count { |f| !f.valid? } == 0
      begin
        FormVersion.transaction do
          form_version.save!
          fields.each { |f| f.save! }
          CurrentForm.where(form_id: form_version.form_id).destroy_all
          form_version.create_current_form!(form_id: form_version.form_id)
        end
      rescue Exception => e
        errors = [e.message]
      end
    else
      errors = form_version.errors.full_messages.uniq + 
               fields.map { |f| f.errors.full_messages }.flatten.uniq
    end
    if errors.any?
      render json: {errors: errors}
    else
      render json: {id: form_version.id, form_id: form_version.form_id}
    end
  end

  def show
    form_version = FormVersion.includes(:user, :published_form).find(params[:id])
    form_versions = FormVersion.where(form_id: form_version.form_id).order(:id).ids
    render json: form_version, meta: {form_versions: form_versions}
  end

  def update
    form_version = FormVersion.find(params.permit(:id)[:id])
    published_form = PublishedForm.find_by(form_id: form_version.form_id)
    if published_form.nil?
      published_form = PublishedForm.new(form_version_id: form_version.id, form_id: form_version.form_id)
    else
      published_form.form_version_id = form_version.id
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

  def form_version_params
    params.require(:form_version).permit(:form_id, :project, :name)
  end

  def field_params
    params.require(:form_version).permit![:fields]
  end

  def publish_params
    params.permit(:form_version_id, :form_id)
  end

end


