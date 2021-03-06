class TopicsController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :get_topic, except: [:index]

  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts
  end

  def edit
  end

  def update
    if @topic.update_attributes(topic_params)
      flash[:success] = "Topic updated."
      redirect_to @topic
    else
      render 'edit'
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:name)
  end

  def get_topic
    @topic = Topic.find(params[:id])
  end 

end

