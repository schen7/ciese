class Api::FormsController < ApplicationController
  
  before_action :api_require_login
  before_action :api_require_staff_or_admin

  def create
    form = FormVersion.new(form_params.merge(user: current_user))
    fields = field_params.map { |f| form.fields.build(f) }
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
    render json: (errors.any? ? {errors: errors} : form)
  end

  # def show
  #   page = Page.includes(:user, :published_page).find(params[:id])
  #   versions = Page.where(page_id: page.page_id).order(:id).ids
  #   render json: page, meta: {versions: versions}
  # end

  # def update
  #   page = Page.find(params.permit(:id)[:id])
  #   published_page = PublishedPage.find_by(page_id: page.page_id)
  #   if published_page.nil?
  #     published_page = PublishedPage.new(version_id: page.id, page_id: page.page_id)
  #   else
  #     published_page.version_id = page.id
  #   end
  #   if published_page.save
  #     render json: {published: true}
  #   else
  #     render json: {published: false, errors: published_page.errors.full_messages}
  #   end
  # end

  # def destroy
  #   page = Page.find(params.permit(:id)[:id])
  #   PublishedPage.where(page_id: page.page_id).destroy_all
  #   render json: {unpublished: true}
  # end

  private

  def form_params
    params.require(:form)
      .permit(:form_id, :name)
  end

  def field_params
    params.require(:form).permit(fields: [:kind, :details])[:fields]
  end

  def publish_params
    params.permit(:form_version_id, :form_id)
  end

end


