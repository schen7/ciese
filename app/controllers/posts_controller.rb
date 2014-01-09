class PostsController < ApplicationController
  before_action :require_login
  #before_action :get_post, except: [:index]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "Post updated."
      redirect_to @post
    else
      render 'edit'
    end
  end

  def new
    @post = Post.new
    @topic = Topic.find(params.permit(:id)[:id])
  end

  def create

    @topic = Topic.find(params.permit(:id)[:id])
    @post = Post.new(new_post_params)

    if @post.save
      flash[:success] = "Post created."
      redirect_to @topic
    else
      render "new"
    end

  end

  private

  def new_post_params
    params.require(:post).permit(:topic_id, :title, :content).tap do |p|
      p[:topic_id] = p[:topic_id]
      p[:author] = current_user.id
      p[:title] = p[:title]
      p[:content] = p[:content]
    end
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
=begin
  def get_post
    @post = Post.find(params[:id])
  end
=end
end
