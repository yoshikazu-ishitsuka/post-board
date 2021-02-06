class CommentsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    if @comment.save
      flash[:alert] = "コメントを投稿しました"
      # redirect_to post_path(@post.id)
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "コメントを（140文字以内で）入力してください。"
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @comments = @post.comments.includes(:user).order(updated_at: "DESC", id: "DESC")
    render "posts/show"
  end

  def update
    if @comment.update(comment_update_params)
      flash[:alert] = "編集が完了しました"  
      redirect_to post_path(@post.id)
      ### success:green, alert:orange, notice:blue, info:light-blue, danger:red, warning:light-yellow
    else
      flash.now[:alert] = 'コメントを(140文字以内で)入力してください。'
      @comments = @post.comments.includes(:user).order(updated_at: "DESC", id: "DESC")
      render "posts/show"
    end
  end

  def destroy
    @comment.destroy
    flash[:alert] = "削除が完了しました"
    redirect_to post_path(@post.id)
  end

  private
  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, post_id: params[:post_id])
  end

  # def set_comment
  #   @post = Post.find(params[:post_id])
  #   @comment = Comment.find(params[:id])
  # end

  def comment_update_params
    params.require(:comment).permit(:text)
  end

  def ensure_correct_user
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    # @comment = current_user.comment.find(params[:id])
    if @comment.user_id != current_user.id
      flash[:alert] = "権限がありません！"
      redirect_back(fallback_location: root_path)
    end
  end
end
