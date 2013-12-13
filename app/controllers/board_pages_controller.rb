class BoardPagesController < ApplicationController
  before_action :require_login
  before_action :require_admin
  #before_action :get_board, except: [:index]
  
  def index
    @boards = Board.all
  end
=begin  
  def show
  end
  
  def edit
  end
  
  def update
    if @board.update_attributes(board_params)
      flash[:success] = "Profile updated."
      log_in(@board)
      redirect_to @board
    else
      render 'edit'
    end
  end
  
  private
  
  def board_params
    params.require(:board).permit(:name)
  end

  def get_board
    @board = Board.find(params[:id])
  end
=end
end
