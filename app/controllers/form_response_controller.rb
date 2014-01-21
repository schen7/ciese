class FormResponseController < ApplicationController

  def new
    @form_version = FormVersion.joins(:published_form).includes(:fields).find_by!(form_params)
    @responses = {}
    @form_version.fields.each { |field| @responses[field.id] = field.responses.build }
    render layout: get_layout(@form_version.project)
  end

  def create
    @form_version = FormVersion.joins(:published_form).includes(:fields).find_by!(form_params)
    @responses = {}
    @form_version.fields.each do |field|
      @responses[field.id] = field.responses.build(get_details(field.id))
    end
    if save_responses
      redirect_to root_path
    else
      render :new, layout: get_layout(@form_version.project)
    end
  end

  private

  def form_params
    params.permit(:project, :slug)
  end

  def response_params
    @response_params = @response_params || params.require(:responses).permit!
  end

  def get_details(field_id)
    { details: response_params[field_id.to_s] }
  end

  def get_layout(project)
    Ciese::PROJECTS[project][:layout]
  end

  def save_responses
    responses_saved = false
    if @responses.values.reject { |r| r.valid? }.empty?
      begin
        FormResponse.transaction { @responses.values.each { |r| r.save! } }
        responses_saved = true
      rescue Exception => e
        @global_errors = [e.message]
      end
    end
    responses_saved
  end
end

