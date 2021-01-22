class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
  end

  def new
    @post = Post.new
  end

  def create
    # byebug
    @post = Post.create(post_params)
    if @post.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:text).merge(user_id: current_user.id)
  end
end
