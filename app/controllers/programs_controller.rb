class ProgramsController < ApplicationController

  def index
    respond_to do |format|
      format.html { render "profiles/index" }
      format.json { render json: Program.all, root: false }
    end
  end
end
