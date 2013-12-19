class PostsController < ApplicationController
  before_action :require_login
  before_action :get_post, except: [:index]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
  end

  def edit
  end

  def update
    if @post.update_attributes(post_params)
      flash[:success] = "Post updated."
      redirect_to @post
    else
      render 'edit'
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def get_post
    @post = Post.find(params[:id])
  end
end
