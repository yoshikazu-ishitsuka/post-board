class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:edit, :update ,:destroy]
  
  def index
    @posts = Post.includes(:user).order(id: "DESC")
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)
    if @post.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:info] = "編集が完了しました"
      # flash: {success: "登録が完了しました"}
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:alert] = "削除が完了しました"
    redirect_to posts_url
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:text).merge(user_id: current_user.id)
  end
end
