class CommentsController < ApplicationController
  before_action :require_login
  before_action :get_comment, except: [:index]

  def index
    @comments = Comment.all
  end

  def create
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def edit
  end

  def update
    if @comment.update_attributes(comment_params)
      flash[:success] = "Comment updated."
      redirect_to @comment
    else
      render 'edit'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :content)
  end

  def get_comment
    @comment = Comment.find(params[:id])
  end
end
