class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:edit, :update ,:destroy, :show]

  def index
    @posts = params[:tag_id].present? ? Tag.find(params[:tag_id]).posts : Post.all
    @posts = @posts.includes(:user).order(updated_at: "DESC", id: "DESC").page(params[:page]).per(5)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)
    if @post.save
      redirect_to root_path, alert: "投稿が完了しました"
    else
      render :new
    end
  end

  def show
    @comments = @post.comments.includes(:user).order(updated_at: "DESC", id: "DESC")
    @comment = Comment.new ###current_user.comments.new
    # @like = Like.new
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to posts_url, flash: { alert: '編集が完了しました' }
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:alert] = "削除が完了しました"
    redirect_to posts_url  ## root_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:text, tag_ids: []).merge(user_id: current_user.id)
  end
end
