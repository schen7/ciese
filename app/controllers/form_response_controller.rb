class FormResponseController < ApplicationController

  before_action :get_form_version
  before_action :get_form_response, only: [:new, :create]

  def new
    @responses = {}
    @form_version.fields.each do |field|
      @responses[field.id] = field.responses.build(form_response: @form_response)
    end
    render layout: get_layout(@form_version.project)
  end

  def create
    @responses = {}
    @form_version.fields.each do |field|
      attrs = { form_response: @form_response, details: response_params[field.id.to_s] }
      @responses[field.id] = field.responses.build(attrs)
    end
    if save_responses
      url = form_done_path(@form_version.project, @form_version.slug)
      redirect_to url, flash: { form_done: true }
    else
      render :new, layout: get_layout(@form_version.project)
    end
  end

  def show
    form_done = flash[:form_done]
    flash.clear
    if form_done
      render layout: get_layout(@form_version.project)
    else
      redirect_to get_project_root_path(@form_version.project) unless form_done
    end
  end

  private

  def get_form_version
    @form_version = FormVersion.joins(:published_form).includes(:fields).find_by!(form_params)
  end

  def get_form_response
    @form_response = FormResponse.new(form_version: @form_version)
  end

  def form_params
    params.permit(:project, :slug)
  end

  def response_params
    @response_params = @response_params || params.permit![:responses] || {}
  end

  def get_details(field_id)
    { details: response_params[field_id.to_s] }
  end

  def get_layout(project)
    Ciese::PROJECTS[project][:layout]
  end

  def get_project_root_path(project)
    Ciese::PROJECTS[project][:root]
  end

  def save_responses
    responses_saved = false
    if @responses.values.reject { |r| r.valid? }.empty?
      begin
        FormFieldResponse.transaction { @responses.values.each { |r| r.save! } }
        responses_saved = true
      rescue Exception => e
        @global_errors = [e.message]
      end
    end
    responses_saved
  end
end

