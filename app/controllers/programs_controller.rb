class ProgramsController < ApplicationController

  def index
    respond_to do |format|
      format.json { render json: Program.all, root: false }
    end
  end
end
