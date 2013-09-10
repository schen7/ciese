class ProgramsController < ApplicationController

  def index
    respond_to do |format|
      format.html { render "profiles/index" }
      format.json { render json: Program.all.order(:name), root: false }
    end
  end

  def create
    @program = Program.new(clean_details(programs_params))
    if @program.save
      render json: @program, root: false
    end
  end

  def update
    @program = Program.find(params.permit(:id)[:id])
    old_attrs = @program.attributes
    new_attrs = programs_params
    if @program.update_attributes(clean_details(new_attrs))
      update_activities(old_attrs, new_attrs) if params[:update_activities] == 'true'
      render json: @program, root: false
    end
  end

  def destroy
    @program = Program.find(params.permit(:id)[:id])
    old_attrs = @program.attributes
    new_attrs = {"name" => "", "details" => old_attrs["details"].map { |d| "" }}
    if @program.destroy
      update_activities(old_attrs, new_attrs) if params[:update_activities] == 'true'
      render json: @program, root: false
    end
  end

  private

  def programs_params
    params.permit(:name, details: [])
  end

  def clean_details(attrs)
    {name: attrs["name"], details: attrs["details"].reject { |d| d.blank? }}
  end

  def update_activities(old_attrs, new_attrs)
    if old_attrs["name"] != new_attrs["name"]
      Activity.where(program: old_attrs["name"])
              .update_all(program: new_attrs["name"])
    end
    old_attrs["details"].each_with_index do |old_detail, i|
      new_detail = new_attrs["details"][i]
      if new_detail and new_detail != old_detail
        Activity.where(program: new_attrs["name"], detail: old_detail)
                .update_all(detail: new_detail)
      end
    end
  end
end
