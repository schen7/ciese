class FormResponseController < ApplicationController

  def new
    @form_version = FormVersion.joins(:published_form).includes(:fields).find_by!(form_params)
    @responses = {}
    @form_version.fields.each do |field|
      @responses[field.id] = field.responses.build
    end
  end

  def create
    @form_version = FormVersion.joins(:published_form).includes(:fields).find_by!(form_params)
    @responses = {}
    @form_version.fields.each do |field|
      details = {details: response_params[field.id.to_s] || {}}
      @responses[field.id] = field.responses.build(details)
    end
    render "new"
  end

  private

  def form_params
    params.permit(:project, :slug)
  end

  def response_params
    @response_params = @response_params || params.require(:responses).permit!
  end

end

