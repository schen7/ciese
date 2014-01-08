class CommentsController < ApplicationController
  before_action :require_login
  before_action :get_comment, except: [:index]

  def index
    @comments = Comment.all
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def edit
  end

  def update
    if @comment.update_attributes(comment_params)
      flash[:success] = "Comment updated."
      redirect_to discussion_comment_path(@comment)
    else
      render 'edit'
    end
  end

  def new
    @comment = Comment.new
    @post = Post.find(params.permit(:id)[:id])
  end

  def create

    @post = Post.find(params.permit(:id)[:id])
    @comment = Comment.new(new_comment_params)
 
    if @comment.save
      flash[:success] = "Comment created."
      redirect_to discussion_post_path(@comment.post_id)
    else
      render "new"
    end

  end

  private

  def new_comment_params
    params.require(:comment).permit(:post_id, :content).tap do |p|
      p[:post_id] = p[:post_id]
      p[:author] = current_user.id
      p[:content] = p[:content]
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def get_comment
    @comment = Comment.find(params[:id])
  end
end
