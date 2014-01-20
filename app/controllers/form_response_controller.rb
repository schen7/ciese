class FormResponseController < ApplicationController

  def new
    @form_version = FormVersion.joins(:published_form).includes(:fields).find_by!(form_params)
  end

  def create
  end

  private

  def form_params
    params.permit(:project, :slug)
  end

end

